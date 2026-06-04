defmodule FindStatePlatesWeb.Router do
  use FindStatePlatesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FindStatePlatesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug FindStatePlatesWeb.UserAuth, :fetch_current_user
  end

  pipeline :redirect_if_user_is_authenticated do
    plug FindStatePlatesWeb.UserAuth, :redirect_if_user_is_authenticated
  end

  pipeline :require_authenticated_user do
    plug FindStatePlatesWeb.UserAuth, :require_authenticated_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FindStatePlatesWeb do
    pipe_through :browser

    get "/", PageController, :home
    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", FindStatePlatesWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
  end

  scope "/", FindStatePlatesWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{FindStatePlatesWeb.UserAuth, :ensure_authenticated}] do
      live "/trips", TripLive.Index, :index
      live "/trips/:id", TripLive.Show, :show
    end
  end

  if Application.compile_env(:find_state_plates, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FindStatePlatesWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
