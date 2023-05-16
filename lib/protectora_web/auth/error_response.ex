defmodule ProtectoraWeb.Auth.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401
end

defmodule ProtectoraWeb.Auth.ErrorResponse.Forbidden do
  defexception message: "You don't have access to this resource", plug_status: 403
end

defmodule ProtectoraWeb.Auth.ErrorResponse.NotFound do
  defexception message: "Not found", plug_status: 404
end
