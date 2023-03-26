defmodule BackalleyWeb.LiveViewNativeHelpers do
  defmacro __using__(opts \\ []) do
    template = Keyword.fetch!(opts, :template)

    quote bind_quoted: [template: template] do
      require EEx

      def render_native(assigns) do
        case assigns do
          %{platform: :web} ->
            render_web(assigns)

          %{platform: :ios} ->
            render_ios(assigns)

          %{platform: :android} ->
            render_android(assigns)

          _ ->
            render_blank(assigns)
        end
      end

      EEx.function_from_file(
        :defp,
        :render_android,
        "lib/backalley_web/live/set_live/#{template}.android.heex",
        [:assigns],
        engine: Phoenix.LiveView.HTMLEngine
      )

      EEx.function_from_file(
        :defp,
        :render_ios,
        "lib/backalley_web/live/set_live/#{template}.ios.heex",
        [:assigns],
        engine: Phoenix.LiveView.HTMLEngine
      )

      EEx.function_from_file(
        :defp,
        :render_web,
        "lib/backalley_web/live/set_live/#{template}.html.heex",
        [:assigns],
        engine: Phoenix.LiveView.HTMLEngine
      )

      EEx.function_from_file(
        :defp,
        :render_blank,
        "lib/backalley_web/live/set_live/game.html.heex",
        [:assigns],
        engine: Phoenix.LiveView.HTMLEngine
      )
    end
  end
end
