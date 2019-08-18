defmodule ZoneMealTracker.DefaultImpl.AccountStore.InMemoryImpl.State do
  @moduledoc false

  import ZoneMealTracker.DefaultImpl.AccountStore.Guards

  alias ZoneMealTracker.DefaultImpl.AccountStore.Login
  alias ZoneMealTracker.DefaultImpl.AccountStore.User

  defstruct [:next_login_id, :next_user_id, :logins, :users, :user_ids_by_credential]

  @opaque t :: %__MODULE__{
            next_login_id: integer,
            next_user_id: integer,
            user_ids_by_credential: %{{User.username(), User.password()} => User.id()},
            logins: [Login.t()],
            users: [User.t()]
          }

  @type new() :: t
  def new do
    %__MODULE__{
      next_login_id: 1,
      next_user_id: 1,
      logins: [],
      users: [],
      user_ids_by_credential: %{}
    }
  end

  @spec create_user(t, String.t(), String.t()) ::
          {{:ok, User.t()} | {:error, :username_not_unique}, t}
  def create_user(%__MODULE__{} = state, username, password) when is_username(username) do
    %__MODULE__{
      next_user_id: next_user_id,
      users: users,
      user_ids_by_credential: user_ids_by_credential
    } = state

    if username_availible?(state, username) do
      user_id = to_string(next_user_id)
      user = %User{id: user_id, username: username}
      user_ids_by_credential = Map.put(user_ids_by_credential, {username, password}, user_id)

      state = %__MODULE__{
        state
        | next_user_id: next_user_id + 1,
          users: [user | users],
          user_ids_by_credential: user_ids_by_credential
      }

      {{:ok, user}, state}
    else
      {{:error, :username_not_unique}, state}
    end
  end

  @spec fetch_user_for_id(t, String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def fetch_user_for_id(%__MODULE__{users: users}, user_id) when is_user_id(user_id) do
    users
    |> Enum.find(&match?(%User{id: ^user_id}, &1))
    |> case do
      %User{} = user ->
        {:ok, user}

      nil ->
        {:error, :not_found}
    end
  end

  @spec fetch_user_by_username_and_password(t, User.username(), User.password()) ::
          {:ok, User.t()} | {:error, :not_found}
  def fetch_user_by_username_and_password(%__MODULE__{} = state, username, password)
      when is_username(username) and is_password(password) do
    with {:ok, user_id} <- fetch_user_id_by_username_and_password(state, username, password),
         {:ok, user} <- fetch_user_for_id(state, user_id) do
      {:ok, user}
    else
      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  @spec delete_user(t, User.id()) :: {:ok, t}
  def delete_user(%__MODULE__{} = state, user_id) when is_user_id(user_id) do
    %__MODULE__{
      logins: logins,
      users: users
    } = state

    users = Enum.reject(users, &match?(%User{id: ^user_id}, &1))
    logins = Enum.reject(logins, &match?(%Login{user_id: ^user_id}, &1))
    state = %__MODULE__{state | users: users, logins: logins}

    {:ok, state}
  end

  @spec create_login(t, User.id()) :: {{:ok, Login.t()} | {:error, :unknown_user_id}, t}
  def create_login(%__MODULE__{} = state, user_id) when is_user_id(user_id) do
    %__MODULE__{
      logins: logins,
      next_login_id: next_login_id
    } = state

    case fetch_user_for_id(state, user_id) do
      {:ok, _user} ->
        login = %Login{id: to_string(next_login_id), user_id: user_id}
        state = %__MODULE__{state | logins: [login | logins], next_login_id: next_login_id + 1}
        {{:ok, login}, state}

      {:error, :not_found} ->
        {{:error, :unknown_user_id}, state}
    end
  end

  @spec fetch_user_for_login_id(t, Login.id()) :: {:ok, User.t()} | {:error, :not_found}
  def fetch_user_for_login_id(%__MODULE__{} = state, login_id) when is_login_id(login_id) do
    with {:ok, %Login{user_id: user_id}} <- fetch_login_for_id(state, login_id),
         {:ok, user} <- fetch_user_for_id(state, user_id) do
      {:ok, user}
    else
      {:error, :not_found} ->
        {:error, :not_found}
    end
  end

  @spec delete_login(t, Login.id()) :: {:ok, t}
  def delete_login(%__MODULE__{logins: logins} = state, login_id) when is_login_id(login_id) do
    logins = Enum.reject(logins, &match?(%Login{id: ^login_id}, &1))
    state = %__MODULE__{state | logins: [logins]}

    {:ok, state}
  end

  @spec username_availible?(t, User.username()) :: boolean
  defp username_availible?(%__MODULE__{users: users}, username) when is_username(username) do
    !Enum.any?(users, &match?(%User{username: ^username}, &1))
  end

  @spec fetch_login_for_id(t, Login.id()) :: {:ok, Login.t()} | {:error, :not_found}
  defp fetch_login_for_id(%__MODULE__{logins: logins}, login_id)
       when is_login_id(login_id) do
    logins
    |> Enum.find(&match?(%Login{id: ^login_id}, &1))
    |> case do
      %Login{} = login ->
        {:ok, login}

      nil ->
        {:error, :not_found}
    end
  end

  @spec fetch_user_id_by_username_and_password(t, User.username(), User.password()) ::
          {:ok, User.id()} | {:error, :not_found}
  defp fetch_user_id_by_username_and_password(%__MODULE__{} = state, username, password)
       when is_username(username) and is_password(password) do
    %__MODULE__{user_ids_by_credential: user_ids_by_credential} = state

    case Map.fetch(user_ids_by_credential, {username, password}) do
      {:ok, user_id} ->
        {:ok, user_id}

      :error ->
        {:error, :not_found}
    end
  end

  @spec reset(t) :: t
  def reset(%__MODULE__{}), do: new()
end
