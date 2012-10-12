defrecord Restmachine.Webmachine.State, state: nil

defmodule Restmachine.Webmachine do
  use Eflow.Machine.Definition

  defmacro __before_compile__(_module) do
    quote do
      use Restmachine.Webmachine.Callbacks
      use Restmachine.Webmachine.Errors
    end
  end

  def define(_) do
    quote do
      @before_compile Restmachine.Webmachine

      def init(req) do
        {:ok, req, nil}
      end
      defoverridable init: 1

      @shortdoc "Starts the Restmachine"
      def start(req) do
        {:ok, req, state} = init(req)
        b13({req, Restmachine.Webmachine.State.new(state: state)})
      end

    end
  end
end