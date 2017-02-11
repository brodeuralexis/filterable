defmodule Filterable.Cast do
  @cast_types ~w(integer float string atom date datetime)a

  # Define functions that raises error.
  for type <- @cast_types do
    def unquote(String.to_atom(Atom.to_string(type) <> "!"))(value) do
      cast!(unquote(type), value)
    end
  end

  def integer(value) when is_bitstring(value) do
    case Integer.parse(value) do
      :error -> nil
      {int, _} -> int
    end
  end
  def integer(value) when is_float(value) do
    round(value)
  end
  def integer(value) when is_integer(value) do
    value
  end
  def integer(_) do
    nil
  end

  def float(value) when is_bitstring(value) do
    case Float.parse(value) do
      :error -> nil
      {int, _} -> int
    end
  end
  def float(value) when is_integer(value) do
    value / 1
  end
  def float(value) when is_float(value) do
    value
  end
  def float(_) do
    nil
  end

  def string(value) when is_bitstring(value) do
    value
  end
  def string(value) do
    Kernel.to_string(value)
  end

  def atom(value) when is_bitstring(value) do
    String.to_atom(value)
  end
  def atom(value) when is_atom(value) do
    value
  end
  def atom(_) do
    nil
  end

  def date(value) when is_bitstring(value) do
    case Date.from_iso8601(value) do
      {:ok, val} -> val
      {:error, _} -> nil
    end
  end
  def date(%Date{} = value) do
    value
  end
  def date(_) do
    nil
  end

  def datetime(value) when is_bitstring(value) do
    case NaiveDateTime.from_iso8601(value) do
      {:ok, val} -> val
      {:error, _} -> nil
    end
  end
  def datetime(%NaiveDateTime{} = value) do
    value
  end
  def datetime(_) do
    nil
  end

  defp cast!(_, nil), do: nil
  defp cast!(type, value) do
    case apply(__MODULE__, type, [value]) do
      nil -> raise Filterable.CastError, type: type, value: value
      val -> val
    end
  end
end