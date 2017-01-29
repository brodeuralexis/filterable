defmodule Filterable.Phoenix.Model do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: [filterable: 2, filterable: 1]

      @before_compile unquote(__MODULE__)
      @filters_module __MODULE__
      @filter_options []
    end
  end

  defmacro __before_compile__(_) do
    quote do
      def apply_filters(%Plug.Conn{} = conn, opts \\ []) do
        options = [share: conn] |> Keyword.merge(opts) |> Keyword.merge(@filter_options)
        Filterable.apply_filters(__MODULE__, conn.params, @filters_module, options)
      end

      def filter_values(%Plug.Conn{} = conn, opts \\ []) do
        options = Keyword.merge(opts, @filter_options)
        Filterable.filter_values(conn.params, @filters_module, options)
      end
    end
  end

  defmacro filterable(module, opts \\ []) do
    quote do
      @filters_module unquote(module)
      @filter_options unquote(opts)
    end
  end
end