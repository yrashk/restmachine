defmodule Restmachine.HTTP do
  defmacro __using__(_) do
    quote do
      import Restmachine.HTTP
    end
  end

  defmacro defstatusnode({name, _, [status, shortdoc]}) do
    __defstatusnode__(name, status, shortdoc, [])
  end
  defmacro defstatusnode({name, _, [status, shortdoc, opts]}) do
    __defstatusnode__(name, status, shortdoc, opts)
  end

  defp __defstatusnode__(name, status, shortdoc, opts) do
    quote do
      @shortdoc "Status code #{unquote(status)}: #{unquote(shortdoc)}"
      defnode unquote(name)({conn, state}) do
       {:ok, conn} = Cage.HTTP.reply(conn, Keyword.merge(unquote(opts), status: unquote(status)))
       {true, {conn, state}}
      end
    end
  end

  defmacro defheadernode({name, _, [header]}) do
    __defheadernode__(name, header, %r(.*), [])
  end
  defmacro defheadernode({name, _, [header, value]}) do
    __defheadernode__(name, header, value, [])
  end  
  defmacro defheadernode({name, _, [header]}, opts) do
    __defheadernode__(name, header, %r(.*), opts)
  end
  defmacro defheadernode({name, _, [header, value]}, opts) do
    __defheadernode__(name, header, value, opts)
  end
  defp __defheadernode__(name, header, value, opts) do
    original_header = header
    header = String.downcase(header)
    quote do
      @shortdoc "Header #{unquote(original_header)}: #{inspect unquote(value)} matches?"
      defnode unquote(name)({conn, state}), unquote(opts) do
        {headers, conn} = Cage.HTTP.headers(conn)
        {_, actual_value} = List.keyfind(headers, unquote(header), 0)
        if is_record(unquote(value), Regex) do
          {Regex.match?(unquote(value), actual_value), {conn, state}}
        else
          {actual_value == unquote(value), {conn, state}}
        end
      end
    end      
  end

end