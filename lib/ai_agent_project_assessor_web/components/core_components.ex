defmodule AiAgentProjectAssessorWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as tables, forms, and
  inputs. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The foundation for styling is Tailwind CSS, a utility-first CSS framework,
  augmented with daisyUI, a Tailwind CSS plugin that provides UI components
  and themes. Here are useful references:

    * [daisyUI](https://daisyui.com/docs/intro/) - a good place to get
      started and see the available components.

    * [Tailwind CSS](https://tailwindcss.com) - the foundational framework
      we build on. You will use it for layout, sizing, flexbox, grid, and
      spacing.

    * [Heroicons](https://heroicons.com) - see `icon/1` for usage.

    * [Phoenix.Component](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html) -
      the component system used by Phoenix. Some components, such as `<.link>`
      and `<.form>`, are defined there.

  """
  use Phoenix.Component
  use Gettext, backend: AiAgentProjectAssessorWeb.Gettext

  alias Phoenix.LiveView.JS

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class="toast toast-top toast-end z-50"
      {@rest}
    >
      <div class={[
        "alert w-80 sm:w-96 max-w-80 sm:max-w-96 text-wrap",
        @kind == :info && "alert-info",
        @kind == :error && "alert-error"
      ]}>
        <.icon :if={@kind == :info} name="hero-information-circle" class="size-5 shrink-0" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle" class="size-5 shrink-0" />
        <div>
          <p :if={@title} class="font-semibold">{@title}</p>
          <p>{msg}</p>
        </div>
        <div class="flex-1" />
        <button type="button" class="group self-start cursor-pointer" aria-label={gettext("close")}>
          <.icon name="hero-x-mark" class="size-5 opacity-40 group-hover:opacity-70" />
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Renders a button with navigation support.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" variant="primary">Send!</.button>
      <.button navigate={~p"/"}>Home</.button>
  """
  attr :rest, :global, include: ~w(href navigate patch method download name value disabled)
  attr :class, :string
  attr :variant, :string, values: ~w(primary)
  slot :inner_block, required: true

  def button(%{rest: rest} = assigns) do
    variants = %{"primary" => "btn-primary", nil => "btn-primary btn-soft"}

    assigns =
      assign_new(assigns, :class, fn ->
        ["btn", Map.fetch!(variants, assigns[:variant])]
      end)

    if rest[:href] || rest[:navigate] || rest[:patch] do
      ~H"""
      <.link class={@class} {@rest}>
        {render_slot(@inner_block)}
      </.link>
      """
    else
      ~H"""
      <button class={@class} {@rest}>
        {render_slot(@inner_block)}
      </button>
      """
    end
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information. Unsupported types, such as hidden and radio,
  are best written directly in your templates.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :string, default: nil, doc: "the input class to use over defaults"
  attr :error_class, :string, default: nil, doc: "the input error class to use over defaults"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div class="fieldset mb-2">
      <label>
        <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
        <span class="label">
          <input
            type="checkbox"
            id={@id}
            name={@name}
            value="true"
            checked={@checked}
            class={@class || "checkbox checkbox-sm"}
            {@rest}
          />{@label}
        </span>
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div class="fieldset mb-2">
      <label>
        <span :if={@label} class="label mb-1">{@label}</span>
        <select
          id={@id}
          name={@name}
          class={[@class || "w-full select", @errors != [] && (@error_class || "select-error")]}
          multiple={@multiple}
          {@rest}
        >
          <option :if={@prompt} value="">{@prompt}</option>
          {Phoenix.HTML.Form.options_for_select(@options, @value)}
        </select>
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div class="fieldset mb-2">
      <label>
        <span :if={@label} class="label mb-1">{@label}</span>
        <textarea
          id={@id}
          name={@name}
          class={[
            @class || "w-full textarea",
            @errors != [] && (@error_class || "textarea-error")
          ]}
          {@rest}
        >{Phoenix.HTML.Form.normalize_value("textarea", @value)}</textarea>
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div class="fieldset mb-2">
      <label>
        <span :if={@label} class="label mb-1">{@label}</span>
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[
            @class || "w-full input",
            @errors != [] && (@error_class || "input-error")
          ]}
          {@rest}
        />
      </label>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  # Helper used by inputs to generate form errors
  defp error(assigns) do
    ~H"""
    <p class="mt-1.5 flex gap-2 items-center text-sm text-error">
      <.icon name="hero-exclamation-circle" class="size-5" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", "pb-4"]}>
      <div>
        <h1 class="text-lg font-semibold leading-8">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="text-sm text-base-content/70">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div class="flex-none">{render_slot(@actions)}</div>
    </header>
    """
  end

  @doc """
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id">{user.id}</:col>
        <:col :let={user} label="username">{user.username}</:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <table class="table table-zebra">
      <thead>
        <tr>
          <th :for={col <- @col}>{col[:label]}</th>
          <th :if={@action != []}>
            <span class="sr-only">{gettext("Actions")}</span>
          </th>
        </tr>
      </thead>
      <tbody id={@id} phx-update={is_struct(@rows, Phoenix.LiveView.LiveStream) && "stream"}>
        <tr :for={row <- @rows} id={@row_id && @row_id.(row)}>
          <td
            :for={col <- @col}
            phx-click={@row_click && @row_click.(row)}
            class={@row_click && "hover:cursor-pointer"}
          >
            {render_slot(col, @row_item.(row))}
          </td>
          <td :if={@action != []} class="w-0 font-semibold">
            <div class="flex gap-4">
              <%= for action <- @action do %>
                {render_slot(action, @row_item.(row))}
              <% end %>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title">{@post.title}</:item>
        <:item title="Views">{@post.views}</:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <ul class="list">
      <li :for={item <- @item} class="list-row">
        <div class="list-col-grow">
          <div class="font-bold">{item.title}</div>
          <div>{render_slot(item)}</div>
        </div>
      </li>
    </ul>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in `assets/vendor/heroicons.js`.

  ## Examples

      <.icon name="hero-x-mark" />
      <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: "size-4"

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  @doc """
  Renders a modal dialog.

  ## Examples

      <.modal id="confirm-modal" show>
        <p>Are you sure?</p>
        <div class="flex justify-end gap-4">
          <.button phx-click={hide_modal("confirm-modal")}>Cancel</.button>
          <.button phx-click="confirm" variant="primary">OK</.button>
        </div>
      </.modal>
  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="hidden relative z-50"
    >
      <div
        id={"#{@id}-bg"}
        class="fixed inset-0 bg-black/50 transition-opacity"
        aria-hidden="true"
      />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center p-4">
          <div
            id={"#{@id}-container"}
            phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
            phx-key="escape"
            phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
            class="w-full max-w-lg bg-white rounded-2xl shadow-xl transition-all"
          >
            <div class="absolute top-4 right-4">
              <button
                phx-click={JS.exec("data-cancel", to: "##{@id}")}
                type="button"
                class="text-gray-400 hover:text-gray-600"
                aria-label={gettext("close")}
              >
                <.icon name="hero-x-mark" class="size-5" />
              </button>
            </div>
            <div id={"#{@id}-content"}>
              {render_slot(@inner_block)}
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  ## JS Commands

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "##{id}-container",
      time: 300,
      transition:
        {"transition-all ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      time: 200,
      transition: {"transition-all ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "##{id}-container",
      time: 200,
      transition:
        {"transition-all ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
    |> JS.hide(to: "##{id}", time: 200)
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(AiAgentProjectAssessorWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(AiAgentProjectAssessorWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  # =============================================================================
  # Loading & State Components
  # =============================================================================

  @doc """
  Renders a loading spinner.

  ## Examples

      <.spinner />
      <.spinner size="lg" />
      <.spinner size="sm" color="primary" />
  """
  attr :size, :string, default: "md", values: ~w(xs sm md lg)
  attr :color, :string, default: "primary", values: ~w(primary secondary accent neutral)
  attr :class, :string, default: nil

  def spinner(assigns) do
    size_class = %{"xs" => "w-4 h-4", "sm" => "w-5 h-5", "md" => "w-8 h-8", "lg" => "w-12 h-12"}

    color_class = %{
      "primary" => "text-[#4CD964]",
      "secondary" => "text-gray-400",
      "accent" => "text-blue-500",
      "neutral" => "text-gray-600"
    }

    assigns =
      assigns
      |> assign(:size_class, Map.get(size_class, assigns.size, "w-8 h-8"))
      |> assign(:color_class, Map.get(color_class, assigns.color, "text-[#4CD964]"))

    ~H"""
    <svg
      class={["animate-spin", @size_class, @color_class, @class]}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      />
    </svg>
    """
  end

  @doc """
  Renders a loading skeleton placeholder.

  ## Examples

      <.skeleton />
      <.skeleton type="text" />
      <.skeleton type="circle" />
      <.skeleton type="card" />
  """
  attr :type, :string, default: "text", values: ~w(text circle card avatar button)
  attr :class, :string, default: nil
  attr :lines, :integer, default: 1

  def skeleton(assigns) do
    ~H"""
    <div class={["animate-pulse", @class]}>
      <%= case @type do %>
        <% "text" -> %>
          <div :for={_ <- 1..@lines} class="h-4 bg-gray-200 rounded-lg mb-2 last:mb-0" />
        <% "circle" -> %>
          <div class="w-12 h-12 bg-gray-200 rounded-full" />
        <% "avatar" -> %>
          <div class="w-10 h-10 bg-gray-200 rounded-full" />
        <% "card" -> %>
          <div class="bg-gray-200 rounded-2xl h-48 w-full" />
        <% "button" -> %>
          <div class="bg-gray-200 rounded-full h-10 w-24" />
        <% _ -> %>
          <div class="h-4 bg-gray-200 rounded-lg" />
      <% end %>
    </div>
    """
  end

  @doc """
  Renders an empty state placeholder.

  ## Examples

      <.empty_state>
        <:icon><.icon name="hero-inbox" /></:icon>
        <:title>No assessments yet</:title>
        <:description>Get started by creating your first assessment.</:description>
        <:action>
          <.button navigate={~p"/assessments/new"}>Create Assessment</.button>
        </:action>
      </.empty_state>
  """
  slot :icon
  slot :title, required: true
  slot :description
  slot :action
  attr :class, :string, default: nil

  def empty_state(assigns) do
    ~H"""
    <div class={["flex flex-col items-center justify-center py-12 px-4 text-center", @class]}>
      <div :if={@icon != []} class="mb-4 text-gray-300">
        <div class="w-16 h-16 flex items-center justify-center">
          {render_slot(@icon)}
        </div>
      </div>
      <h3 class="text-lg font-medium text-gray-900 mb-2">
        {render_slot(@title)}
      </h3>
      <p :if={@description != []} class="text-sm text-gray-500 mb-6 max-w-sm">
        {render_slot(@description)}
      </p>
      <div :if={@action != []}>
        {render_slot(@action)}
      </div>
    </div>
    """
  end

  @doc """
  Renders an error state with retry option.

  ## Examples

      <.error_state message="Failed to load data">
        <:action>
          <.button phx-click="retry">Try Again</.button>
        </:action>
      </.error_state>
  """
  attr :title, :string, default: "Something went wrong"
  attr :message, :string, default: nil
  attr :class, :string, default: nil
  slot :action

  def error_state(assigns) do
    ~H"""
    <div class={[
      "flex flex-col items-center justify-center py-12 px-4 text-center bg-red-50 rounded-2xl",
      @class
    ]}>
      <div class="w-16 h-16 mb-4 flex items-center justify-center bg-red-100 rounded-full">
        <svg class="w-8 h-8 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
          />
        </svg>
      </div>
      <h3 class="text-lg font-medium text-red-900 mb-2">{@title}</h3>
      <p :if={@message} class="text-sm text-red-700 mb-6 max-w-sm">{@message}</p>
      <div :if={@action != []}>
        {render_slot(@action)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a progress bar.

  ## Examples

      <.progress_bar value={75} />
      <.progress_bar value={50} color="warning" />
  """
  attr :value, :integer, required: true, doc: "Percentage 0-100"
  attr :color, :string, default: "primary", values: ~w(primary success warning error)
  attr :size, :string, default: "md", values: ~w(xs sm md lg)
  attr :show_label, :boolean, default: false
  attr :class, :string, default: nil

  def progress_bar(assigns) do
    color_class = %{
      "primary" => "bg-[#4CD964]",
      "success" => "bg-green-500",
      "warning" => "bg-yellow-500",
      "error" => "bg-red-500"
    }

    size_class = %{
      "xs" => "h-1",
      "sm" => "h-2",
      "md" => "h-3",
      "lg" => "h-4"
    }

    assigns =
      assigns
      |> assign(:color_class, Map.get(color_class, assigns.color, "bg-[#4CD964]"))
      |> assign(:size_class, Map.get(size_class, assigns.size, "h-3"))

    ~H"""
    <div class={["w-full", @class]}>
      <div :if={@show_label} class="flex justify-between mb-1">
        <span class="text-sm font-medium text-gray-700">Progress</span>
        <span class="text-sm font-medium text-gray-700">{@value}%</span>
      </div>
      <div class={["w-full bg-gray-200 rounded-full overflow-hidden", @size_class]}>
        <div
          class={["transition-all duration-300 ease-out rounded-full", @size_class, @color_class]}
          style={"width: #{min(100, max(0, @value))}%"}
        />
      </div>
    </div>
    """
  end

  @doc """
  Renders a badge/tag.

  ## Examples

      <.badge>Default</.badge>
      <.badge color="success">Active</.badge>
      <.badge color="warning" size="lg">Pending</.badge>
  """
  attr :color, :string,
    default: "neutral",
    values: ~w(neutral primary success warning error info)

  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def badge(assigns) do
    color_class = %{
      "neutral" => "bg-gray-100 text-gray-800",
      "primary" => "bg-green-100 text-green-800",
      "success" => "bg-green-100 text-green-800",
      "warning" => "bg-yellow-100 text-yellow-800",
      "error" => "bg-red-100 text-red-800",
      "info" => "bg-blue-100 text-blue-800"
    }

    size_class = %{
      "sm" => "px-2 py-0.5 text-xs",
      "md" => "px-2.5 py-1 text-xs",
      "lg" => "px-3 py-1.5 text-sm"
    }

    assigns =
      assigns
      |> assign(:color_class, Map.get(color_class, assigns.color, "bg-gray-100 text-gray-800"))
      |> assign(:size_class, Map.get(size_class, assigns.size, "px-2.5 py-1 text-xs"))

    ~H"""
    <span class={[
      "inline-flex items-center font-medium rounded-full",
      @color_class,
      @size_class,
      @class
    ]}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a card component.

  ## Examples

      <.card>
        <:header>Card Title</:header>
        Content goes here
        <:footer>Footer content</:footer>
      </.card>
  """
  attr :class, :string, default: nil
  attr :padding, :string, default: "md", values: ~w(none sm md lg)
  slot :header
  slot :inner_block, required: true
  slot :footer

  def card(assigns) do
    padding_class = %{
      "none" => "",
      "sm" => "p-4",
      "md" => "p-6",
      "lg" => "p-8"
    }

    assigns = assign(assigns, :padding_class, Map.get(padding_class, assigns.padding, "p-6"))

    ~H"""
    <div class={["bg-white rounded-2xl shadow-sm border border-gray-200", @class]}>
      <div :if={@header != []} class="px-6 py-4 border-b border-gray-200">
        <h3 class="text-lg font-semibold text-gray-900">
          {render_slot(@header)}
        </h3>
      </div>
      <div class={@padding_class}>
        {render_slot(@inner_block)}
      </div>
      <div :if={@footer != []} class="px-6 py-4 border-t border-gray-200 bg-gray-50 rounded-b-2xl">
        {render_slot(@footer)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a loading overlay for async operations.

  ## Examples

      <.loading_overlay :if={@loading} message="Processing..." />
  """
  attr :message, :string, default: "Loading..."
  attr :class, :string, default: nil

  def loading_overlay(assigns) do
    ~H"""
    <div class={[
      "fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm",
      @class
    ]}>
      <div class="bg-white rounded-2xl shadow-xl p-8 flex flex-col items-center">
        <.spinner size="lg" />
        <p class="mt-4 text-gray-600 font-medium">{@message}</p>
      </div>
    </div>
    """
  end

  @doc """
  Renders a confirmation dialog.

  ## Examples

      <.confirm_dialog
        id="delete-confirm"
        title="Delete Assessment?"
        message="This action cannot be undone."
        confirm_text="Delete"
        confirm_variant="error"
        on_confirm={JS.push("delete")}
      />
  """
  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :message, :string, default: nil
  attr :confirm_text, :string, default: "Confirm"
  attr :cancel_text, :string, default: "Cancel"
  attr :confirm_variant, :string, default: "primary", values: ~w(primary error warning)
  attr :on_confirm, JS, required: true
  attr :on_cancel, JS, default: %JS{}

  def confirm_dialog(assigns) do
    confirm_class = %{
      "primary" => "bg-[#4CD964] hover:bg-[#3DBF55] text-white",
      "error" => "bg-red-500 hover:bg-red-600 text-white",
      "warning" => "bg-yellow-500 hover:bg-yellow-600 text-white"
    }

    assigns = assign(assigns, :confirm_class, Map.get(confirm_class, assigns.confirm_variant))

    ~H"""
    <.modal id={@id} on_cancel={@on_cancel}>
      <div class="p-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-2">{@title}</h3>
        <p :if={@message} class="text-gray-600 mb-6">{@message}</p>
        <div class="flex justify-end gap-3">
          <button
            type="button"
            phx-click={hide_modal(@id) |> JS.exec(@on_cancel)}
            class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-full font-medium transition-colors"
          >
            {@cancel_text}
          </button>
          <button
            type="button"
            phx-click={hide_modal(@id) |> JS.exec(@on_confirm)}
            class={["px-4 py-2 rounded-full font-medium transition-colors", @confirm_class]}
          >
            {@confirm_text}
          </button>
        </div>
      </div>
    </.modal>
    """
  end

  @doc """
  Renders a status indicator dot.

  ## Examples

      <.status_dot status="online" />
      <.status_dot status="busy" />
  """
  attr :status, :string,
    default: "neutral",
    values: ~w(online offline busy away neutral success error warning)

  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :pulse, :boolean, default: false
  attr :class, :string, default: nil

  def status_dot(assigns) do
    color_class = %{
      "online" => "bg-green-500",
      "success" => "bg-green-500",
      "offline" => "bg-gray-400",
      "neutral" => "bg-gray-400",
      "busy" => "bg-red-500",
      "error" => "bg-red-500",
      "away" => "bg-yellow-500",
      "warning" => "bg-yellow-500"
    }

    size_class = %{
      "sm" => "w-2 h-2",
      "md" => "w-3 h-3",
      "lg" => "w-4 h-4"
    }

    assigns =
      assigns
      |> assign(:color_class, Map.get(color_class, assigns.status, "bg-gray-400"))
      |> assign(:size_class, Map.get(size_class, assigns.size, "w-3 h-3"))

    ~H"""
    <span class={["relative inline-flex", @class]}>
      <span class={["rounded-full", @size_class, @color_class]} />
      <span
        :if={@pulse}
        class={[
          "animate-ping absolute inline-flex h-full w-full rounded-full opacity-75",
          @color_class
        ]}
      />
    </span>
    """
  end
end
