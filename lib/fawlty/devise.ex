defmodule Fawlty.Devise do

  @moduledoc """

  """

  alias Plug.Conn
  alias Fawlty.User

  @doc """

  info:
  %{"email" => "roloenusa@gmail.com",
  "family_name" => "Delgado",
  "gender" => "male",
  "given_name" => "Juan",
  "id" => "104022302979988119673",
  "link" => "https://plus.google.com/104022302979988119673",
  "name" => "Juan Delgado",
  "picture" => "https://lh6.googleusercontent.com/-W_XybLgvfZ4/AAAAAAAAAAI/AAAAAAAADI0/RzwBpi7-H1w/photo.jpg",
  "verified_email" => true}


  token:
  %OAuth2Ex.Token{access_token: "ya29.4gCVyry6FZXxWrore-oDpqSGeHxeJ4u-7T9SXPLlxs2UOr47LqCcHDtX",
                  auth_header: "Bearer",
                  config: nil,
                  expires_at: 1419069005,
                  expires_in: 3600,
                  refresh_token: nil,
                  storage: nil,
                  token_type: "Bearer"}
  """
  def init_session(%{"email"=> email} = info, token) do

    case User.find_by_email(email) do
      nil   ->
        create_user(info);
      user  -> user
    end
  end

  defp create_user(%{"email" => email, "given_name"=> given_name}) do
    %User{name: given_name, email: email}
      |> User.create
  end
end
