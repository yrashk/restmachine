defmodule Restmachine.Webmachine.Callbacks do
  defmacro __using__(_) do
    quote do
      import Restmachine.Callback

      @shortdoc "Is service available?"
      defvaluenode b13(available?(true)), true: b12, false: a13

      @shortdoc "Known method?"
      defvaluenode b12(known_method?(true)), true: b11, false: a12

      @shortdoc "URI too long?"
      defvaluenode b11(uri_too_long?(false)), true: a11, false: b10

      @shortdoc "Is method allowed on this resource?"
      if Module.defines? __MODULE__, {:allowed_methods, 2} do
        defnode b10({req, Restmachine.Webmachine.State[state: s] = state}), true: b9, false: a10 do
          {value, req, s} = allowed_methods(req, s)
          {method, req} = Cage.HTTP.method(req)
          {List.member?(value, method), {req, Restmachine.Webmachine.State.state(s, state)}}        
        end
      else
        defnode b10({req, state}), true: b9, false: a10 do
          {true, {req, state}}
        end      
      end

      @shortdoc "Malformed?"
      defvaluenode b9(malformed?(false)), true: a9, false: b8

      @shortdoc "Authorized?"
      defvaluenode b8(authorized?(true)), true: b7, false: a8

      @shortdoc "Forbidden?"
      defvaluenode b7(forbidden?(false)), true: a7, false: b6

      @shortdoc "Valid Content-* header?"
      defvaluenode b6(valid_content_headers?(true)), false: a6, true: b5

      @shortdoc "Valid Content-Type?"
      defvaluenode b5(known_content_type?(true)), false: a5, true: b4

      @shortdoc "Valid entity length?"
      defvaluenode b4(valid_entity_length?(true)), true: finish, false: a4

    end
  end
end