defmodule Restmachine.Callback do
  defmacro __using__(_) do
    quote do
      import Restmachine.Callback
    end
  end

  defmacro defvaluenode({name, _, [{callback, _, [default]}]}) do
    __defvaluenode__(name, callback, default, [])
  end
  defmacro defvaluenode({name, _, [{callback, _, [default]}]}, opts) do
    __defvaluenode__(name, callback, default, opts)  
  end  
  defp __defvaluenode__(name, callback, default, opts) do
    quote do
      unless Module.defines? __MODULE__, {unquote(callback), 2} do
        defnode unquote(name)({conn, state}), unquote(opts) do
         {unquote(default), {conn, state}}
        end
      else
        defnode unquote(name)({conn, state}), unquote(opts) do          
         {value, conn, state} = unquote(callback)(conn, state)
         {value, {conn, state}}
        end          
      end
    end
  end
end