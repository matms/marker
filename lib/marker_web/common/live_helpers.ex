defmodule MarkerWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update the URL
  when the modal is closed.

  You may override the outer HTML class by using :modal_class, and the inner
  HTML class by using :modal_content_class. However, you probably want to
  _extend_ rather than override these, in which case you should pass in
  :modal_class_add or :modal_content_class_add respectively.

  ## Examples

      <.modal return_to={Routes.bookmark_index_path(@socket, :index)}>
        <.live_component
          module={MarkerWeb.Library.Bookmark.FormComponent}
          id={@bookmark.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.bookmark_index_path(@socket, :index)}
          bookmark: @bookmark
        />
      </.modal>

      <.modal
        return_to={Routes.bookmark_index_path(@socket, :index)}
        modal_content_class_add="max-w-md"
      >
        ...
      </.modal>

  """
  def modal(assigns) do
    assigns =
      assigns
      |> assign_new(:return_to, fn -> nil end)
      |> assign_new(:modal_class, fn -> "phx-modal fade-in" end)
      |> assign_new(:modal_content_class, fn -> "phx-modal-content fade-in-scale" end)

    assigns =
      if Map.has_key?(assigns, :modal_class_add) do
        assign(assigns, :modal_class, assigns.modal_class <> " " <> assigns.modal_class_add)
      else
        assigns
      end

    assigns =
      if Map.has_key?(assigns, :modal_content_class_add) do
        assign(
          assigns,
          :modal_content_class,
          assigns.modal_content_class <> " " <> assigns.modal_content_class_add
        )
      else
        assigns
      end

    ~H"""
    <div id="modal" class={@modal_class} phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class={@modal_content_class}
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch(
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          ) do %>
            <!-- From https://heroicons.com/ -->
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          <% end %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close font-mono" phx-click={hide_modal()}>
            <!-- From https://heroicons.com/ -->
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
