defmodule ProtectoraWeb.Auth.Guardian do
  use Guardian, otp_app: :protectora
  alias Protectora.Voluntarios

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)

    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Voluntarios.get_voluntario!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  # Authentication

  def authenticate(email, password) do
    case Voluntarios.get_voluntario_by_email(email) do
      nil ->
        {:error, :unauthored}

      account ->
        case validate_password(password, account.contrasinal) do
          true -> create_token(account, :access)
          false -> {:error, :unauthorized}
        end
    end
  end

  def authenticate(token) do
    with {:ok, claims} <- decode_and_verify(token),
         {:ok, account} <- resource_from_claims(claims),
         {:ok, _old, {new_token, _claims}} <- refresh(token) do
      {:ok, account, new_token}
    end
  end

  defp validate_password(password, hashed_password) do
    Bcrypt.verify_pass(password, hashed_password)
  end

  defp create_token(account, type) do
    {:ok, token, _claims} = encode_and_sign(account, %{}, token_options(type))
    {:ok, account, token}
  end

  defp token_options(type) do
    case type do
      :access -> [token_type: "access", ttl: {2, :hour}]
    end
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end
