defmodule ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl do
  @moduledoc false

  import ZoneMealTracker.DefaultImpl.AccountStore.Guards
  import Ecto.Query

  alias Ecto.Changeset
  alias Ecto.Queryable
  alias Ecto.UUID
  alias ZoneMealTracker.DefaultImpl.AccountStore
  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.DomainTranslator
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.InvalidDataError
  alias ZoneMealTracker.DefaultImpl.AccountStore.PostgresImpl.Repo
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  @behaviour ZoneMealTracker.DefaultImpl.AccountStore.Impl

  @doc false
  defdelegate child_spec(opts), to: __MODULE__.Supervisor

  @impl true
  @spec create_user(User.email(), User.password()) ::
          {:ok, User.t()} | {:error, :email_not_unique}
  def create_user(email, password) when is_email(email) and is_password(password) do
    %PostgresImpl.User{}
    |> PostgresImpl.User.changeset(%{email: email, password: password})
    |> Repo.insert()
    |> case do
      {:ok, %PostgresImpl.User{} = user} ->
        {:ok, DomainTranslator.to_domain_user(user)}

      {:error, %Changeset{errors: errors}} ->
        if Enum.any?(errors, &match?({:email, {"is_already_registered", _}}, &1)) do
          {:error, :email_not_unique}
        else
          raise InvalidDataError, errors: errors
        end
    end
  end

  @spec fetch_user_for_id(User.id()) :: {:ok, User.t()}
  def fetch_user_for_id(user_id) when is_user_id(user_id) do
    with {:ok, user_id} <- UUID.cast(user_id),
         query = user_query() |> with_user_id(user_id),
         %PostgresImpl.User{} = user <- Repo.one(query) do
      {:ok, DomainTranslator.to_domain_user(user)}
    else
      _ ->
        {:error, :not_found}
    end
  end

  @impl true
  @spec fetch_user_by_email_and_password(User.email(), User.password()) ::
          {:ok, User.t()} | {:error, :not_found}
  def fetch_user_by_email_and_password(email, password)
      when is_email(email) and is_password(password) do
    query = user_query() |> with_email(email)

    with %PostgresImpl.User{password_hash: password_hash} = user <- Repo.one(query),
         true <- Argon2.verify_pass(password, password_hash) do
      {:ok, DomainTranslator.to_domain_user(user)}
    else
      _ ->
        {:error, :not_found}
    end
  end

  @spec delete_user(User.id()) :: :ok
  def delete_user(user_id) when is_user_id(user_id) do
    case UUID.cast(user_id) do
      {:ok, user_id} ->
        user_query() |> with_user_id(user_id) |> Repo.delete_all()
        :ok

      :error ->
        :ok
    end
  end

  @impl true
  @spec create_login(User.id()) :: {:ok, Login.t()} | {:error, :unknown_user_id}
  def create_login(user_id) when is_user_id(user_id) do
    %PostgresImpl.Login{}
    |> PostgresImpl.Login.changeset(%{user_id: user_id})
    |> Repo.insert()
    |> case do
      {:ok, %PostgresImpl.Login{} = login} ->
        {:ok, DomainTranslator.to_domain_login(login)}

      {:error, %Changeset{errors: errors}} ->
        if Enum.any?(errors, &match?({:user_id, _}, &1)) do
          {:error, :unknown_user_id}
        else
          raise InvalidDataError, errors: errors
        end
    end
  end

  @impl true
  @spec fetch_user_for_login_id(Login.id()) :: {:ok, User.t()} | {:error, :not_found}
  def fetch_user_for_login_id(login_id) when is_login_id(login_id) do
    with {:ok, login_id} <- UUID.cast(login_id),
         query = user_query() |> ensure_login_joined() |> with_login_id(login_id),
         %PostgresImpl.User{} = login <- Repo.one(query) do
      {:ok, DomainTranslator.to_domain_user(login)}
    else
      _ ->
        {:error, :not_found}
    end
  end

  @impl true
  @spec delete_login(Login.id()) :: :ok
  def delete_login(login_id) when is_login_id(login_id) do
    case UUID.cast(login_id) do
      {:ok, login_id} ->
        login_query()
        |> with_login_id(login_id)
        |> Repo.delete_all()

        :ok

      :error ->
        :ok
    end
  end

  @impl true
  @spec reset([AccountStore.reset_opt()]) :: :ok
  def reset(opts) when is_list(opts) do
    case Keyword.fetch(opts, :force) do
      {:ok, true} ->
        user_query() |> Repo.delete_all()

        :ok

      _ ->
        raise ArgumentError, "{:force, true} is required to reset this system"
    end
  end

  @spec user_query() :: Queryable.t()
  defp user_query do
    from PostgresImpl.User, as: :user
  end

  @spec login_query() :: Queryable.t()
  defp login_query do
    from PostgresImpl.Login, as: :login
  end

  @spec with_user_id(Queryable.t(), User.id()) :: Queryable.t()
  defp with_user_id(queryable, id) when is_user_id(id) do
    where(queryable, [user: user], user.id == ^id)
  end

  @spec with_email(Queryable.t(), User.email()) :: Queryable.t()
  defp with_email(queryable, email) when is_email(email) do
    where(queryable, [user: user], user.email == ^email)
  end

  @spec with_login_id(Queryable.t(), Login.id()) :: Queryable.t()
  defp with_login_id(queryable, login_id) when is_login_id(login_id) do
    where(queryable, [login: login], login.id == ^login_id)
  end

  @spec ensure_login_joined(Queryable.t()) :: Queryable.t()
  defp ensure_login_joined(queryable) do
    ensure_has_binding(queryable, :login, fn q ->
      join(q, :left, [user: user], login in PostgresImpl.Login,
        on: user.id == login.user_id,
        as: :login
      )
    end)
  end

  @spec ensure_has_binding(Queryable.t(), atom, (Queryable.t() -> Queryable.t())) :: Queryable.t()
  defp ensure_has_binding(queryable, binding_name, bind_fn) when is_function(bind_fn, 1) do
    if has_named_binding?(queryable, binding_name) do
      queryable
    else
      bind_fn.(queryable)
    end
  end
end
