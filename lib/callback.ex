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
    unused_choices = 
    case Macro.safe_term(default) do
      :ok -> (lc {name, _} inlist opts, name != default, do: name)
      _ -> []
    end
    undefined_opts = lc name inlist Keyword.keys(opts) -- unused_choices, do: {name, opts[name]}
    undefined_funs = lc name inlist unused_choices, do: {elem(opts[name], 0), 1}
    quote do
      unless Module.defines? __MODULE__, {unquote(callback), 2} do
        @compile {:nowarn_unused_function, unquote(undefined_funs)}
        defnode unquote(name)({conn, state}), unquote(undefined_opts) do
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