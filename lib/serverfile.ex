defmodule Dos1Server do
  require Logger

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket,port)
  end

  defp loop_acceptor(server_socket,port) do
    {:ok, client} = :gen_tcp.accept(server_socket)
    serve(client,port,server_socket)
    loop_acceptor(server_socket,port)
  end

  defp serve(client_socket,port,server_socket) do
    IO.puts("Connection established..............")
    read_line(client_socket,port)
    |> write_line()
  end

  defp read_line(client_socket,port) do
    {:ok, data} = :gen_tcp.recv(client_socket, 0)
    IO.puts("Got the input to calculate....")
    ok = :gen_tcp.close(client_socket)
    data = String.replace(data,"\r"," ")
    data = String.replace(data,"\n"," ")
    nums = String.split(data," ")
    nums = [Enum.at(nums,0),Enum.at(nums,1),Enum.at(nums,2)]
    IO.inspect nums
    nums = Enum.map(nums,fn(x)->
      IO.puts(is_binary(x))
      x = String.to_integer(x)
    end)
    IO.inspect nums
    nums
  end

  defp write_line(nums) do
    fangs = StartCalc.pilot(Enum.at(nums,0),Enum.at(nums,1),Enum.at(nums,2))
    IO.puts("Calculated fangs......")
    fangs = elem(fangs,2)
    IO.inspect fangs
    fangs = Enum.map(fangs,fn(x)->
      Enum.join(Tuple.to_list(x)," ")
    end)

    fangs = fangs ++ ["bye\r\n"]

    opts = [:binary, active: true, packet: :line]
    {:ok, socket} = :gen_tcp.connect({192,168,0,163}, 4044, opts)
    IO.inspect socket
    Enum.each(fangs,fn(x)->
      case :gen_tcp.send(socket, x<>"\r\n") do
        :ok -> IO.puts("data sent")
        {:error, reason} ->
          Logger.error "Couldn't send message: #{inspect reason}"
      end
    end)
    IO.puts("all data sent")
    ok = :gen_tcp.close(socket)

  end
end

# Dos1Server.accept(4043)
