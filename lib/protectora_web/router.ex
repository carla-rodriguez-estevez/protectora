defmodule ProtectoraWeb.Router do
  use ProtectoraWeb, :router
  use Plug.ErrorHandler

  import ProtectoraWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {ProtectoraWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:fetch_session)

    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug :fetch_session

    plug(ProtectoraWeb.Auth.Pipeline)
    plug(ProtectoraWeb.Auth.SetAccount)
  end

  scope "/", ProtectoraWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    live("/voluntario", VoluntarioLive.Index, :index)
    live("/voluntario/new", VoluntarioLive.Index, :new)
    live("/voluntario/:id/edit", VoluntarioLive.Index, :edit)

    live("/voluntario/:id", VoluntarioLive.Show, :show)
    live("/voluntario/:id/show/edit", VoluntarioLive.Show, :edit)

    live("/publicacion", PublicacionLive.Index, :index)
    live("/publicacion/new", PublicacionLive.Index, :new)
    live("/publicacion/:id/edit", PublicacionLive.Index, :edit)

    live("/publicacion/:id", PublicacionLive.Show, :show)
    live("/publicacion/:id/show/edit", PublicacionLive.Show, :edit)

    live("/colaborador", ColaboradorLive.Index, :index)
    live("/colaborador/new", ColaboradorLive.Index, :new)
    live("/colaborador/:id/edit", ColaboradorLive.Index, :edit)

    live("/colaborador/:id", ColaboradorLive.Show, :show)
    live("/colaborador/:id/show/edit", ColaboradorLive.Show, :edit)

    live("/animal", AnimalLive.Index, :index)
    live("/animal/new", AnimalLive.Index, :new)
    live("/animal/:id/edit", AnimalLive.Index, :edit)

    live("/animal/:id", AnimalLive.Show, :show)
    live("/animal/:id/show/edit", AnimalLive.Show, :edit)

    live("/rexistro", RexistroLive.Index, :index)
    live("/rexistro/new", RexistroLive.Index, :new)
    live("/rexistro/:id/edit", RexistroLive.Index, :edit)
    live("/rexistro/:id", RexistroLive.Show, :show)
    live("/rexistro/:id/show/edit", RexistroLive.Show, :edit)

    live("/padrinamento", PadrinamentoLive.Index, :index)
    live("/padrinamento/new", PadrinamentoLive.Index, :new)
    live("/padrinamento/:id/edit", PadrinamentoLive.Index, :edit)

    live("/padrinamento/:id", PadrinamentoLive.Show, :show)
    live("/padrinamento/:id/show/edit", PadrinamentoLive.Show, :edit)
  end

  defp handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  defp handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  scope "/api", ProtectoraWeb do
    pipe_through(:api)

    get("/", DefaultController, :index)

    post("/voluntario/sign_in", VoluntarioController, :sign_in)
    post "/voluntario", VoluntarioController, :create

    resources("/colaborador", ColaboradorController, except: [:new, :edit])
    resources("/publicacion", PublicacionController, except: [:new, :edit])
    resources("/animal", AnimalController, except: [:new, :edit])
    resources("/rexistro", RexistroController, except: [:new, :edit])
    resources("/padrinamento", PadrinamentoController, except: [:new, :edit])

    # resources "/imaxe_pVoluntarioControllerublicacion", ImaxePublicacionController, except: [:new, :edit]
  end

  scope "/api", ProtectoraWeb do
    pipe_through([:api, :auth])

    get "/voluntario", VoluntarioController, :index
    get "/voluntario/:id", VoluntarioController, :show
    get "/voluntario/:id/edit", VoluntarioController, :edit
    put "/voluntario/:id", VoluntarioController, :update
    patch "/voluntario/:id", VoluntarioController, :update
    delete "/voluntario/:id", VoluntarioController, :delete

    get("/voluntario/get/:id", VoluntarioController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ProtectoraWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: ProtectoraWeb.Telemetry)
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", ProtectoraWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", ProtectoraWeb do
    pipe_through([:browser, :require_authenticated_user])

    # get "/users/settings", UserSettingsController, :edit
    # put "/users/settings", UserSettingsController, :update
  end

  scope "/", ProtectoraWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)
  end
end
