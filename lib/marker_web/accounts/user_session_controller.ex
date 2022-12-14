defmodule MarkerWeb.Accounts.UserSessionController do
  use MarkerWeb, :controller

  alias Marker.Accounts
  alias MarkerWeb.Accounts.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = get_user(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  defp get_user(email, password) do
    if Accounts.allow_login_with_any_password() do
      Accounts.get_user_by_email(email)
    else
      Accounts.get_user_by_email_and_password(email, password)
    end
  end
end
