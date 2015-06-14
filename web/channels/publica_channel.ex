defmodule Fawlty.PublicaChannel do
    use Phoenix.Channel
    import Logger

    def join(socket, "temario", _message) do
        Logger.error "==== subs to temario"
        {:ok, socket}
    end

    def event(socket, "temario", params) do
        broadcast socket, "create:item", %{thereq: params}
        Logger.error "==== Temario: #{params}"
        socket
    end
end
