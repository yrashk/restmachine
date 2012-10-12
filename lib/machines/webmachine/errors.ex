defmodule Restmachine.Webmachine.Errors do
  defmacro __using__(_) do
    quote do
      import Restmachine.HTTP

      defstatusnode a13(503,"Service Unavailable")
      defstatusnode a12(501,"Not Implemented")      
      defstatusnode a11(414,"Request URI Too Long")      
      defstatusnode a10(405,"Method Not Allowed")      
      defstatusnode a9(400,"Bad Request")
      defstatusnode a8(401,"Unauthorized")
      defstatusnode a7(403,"Forbidden")
      defstatusnode a6(501,"Not Implemented")
      defstatusnode a5(415,"Unsupported Media Type")
      defstatusnode a4(413,"Request Entity Too Large")

    end
  end
end