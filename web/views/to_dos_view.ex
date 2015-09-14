defmodule Fawlty.ToDosView do
  use Fawlty.View
  import Logger

  @apis [
    "items.json",
    "toggle.json"
  ]

  def render(api, %{response: response}) when api in @apis do
    response
  end
end
