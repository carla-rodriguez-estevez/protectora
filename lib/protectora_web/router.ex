defmodule ProtectoraWeb.Router do
  use ProtectoraWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {ProtectoraWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
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

  scope "/api", ProtectoraWeb do
    pipe_through(:api)

    get("/", DefaultController, :index)

    resources("/voluntario", VoluntarioController, except: [:new, :edit])
    resources("/colaborador", ColaboradorController, except: [:new, :edit])
    resources("/publicacion", PublicacionController, except: [:new, :edit])
    resources("/animal", AnimalController, except: [:new, :edit])
    resources("/rexistro", RexistroController, except: [:new, :edit])
    resources("/padrinamento", PadrinamentoController, except: [:new, :edit])

    # resources "/imaxe_publicacion", ImaxePublicacionController, except: [:new, :edit]
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
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: ProtectoraWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
