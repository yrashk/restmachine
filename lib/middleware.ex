defmodule Restmachine.Middleware do
  use Cage.Middleware

   def call(conn, state, machine) do
    {conn, _} = machine.start(conn)
    {conn, state}
  end
end