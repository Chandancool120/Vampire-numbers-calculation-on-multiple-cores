defmodule Dos1Client do
  require Logger

  def make_connections(port) do
    server1 = {192,168,0,163}
    opts = [:binary, :inet, active: true, packet: :line]
    {:ok, socket} = :gen_tcp.connect({192,168,0,163}, port, opts)
    IO.inspect socket
    case :gen_tcp.send(socket, "0 100000 200000\r\n") do
      :ok -> :ok
      {:error, reason} ->
        Logger.error "Couldn't send message: #{inspect reason}"
    end


    ok = :gen_tcp.close(socket)
    # server1 = {192,168,0,163}
    # opts = [:binary, :inet, active: true, packet: :line]
    # {:ok, socket} = :gen_tcp.connect({192,168,0,163}, port, opts)
    # IO.inspect socket
    # case :gen_tcp.send(socket, "1 100000 200000\r\n") do
    #   :ok -> :ok
    #   {:error, reason} ->
    #     Logger.error "Couldn't send message: #{inspect reason}"
    # end


    # ok = :gen_tcp.close(socket)
    port = 4044
    IO.inspect port
    {:ok, socket} =:gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    IO.puts("listening on port...........")
    {:ok, client} = :gen_tcp.accept(socket)
    IO.puts("Connection established on client......")
    # {:ok, data} = :gen_tcp.recv(client, 0)
    # case :gen_tcp.recv(client, 0) do
    #   :ok -> IO.puts("data received")
    #   {:error, reason} ->
    #     Logger.error "Couldn't receive message: #{inspect reason}"
    # end
    list = print_data(client,"do",[])
    list = list -- ["bye\r\n"]
    IO.inspect list
  end
  def print_data(client,"bye\r\n",list) do
    IO.puts("done")
    list
  end

  def print_data(client,condition,list) do
    {:ok,data} = :gen_tcp.recv(client, 0)
    list = list ++ [data]
    list = print_data(client,data,list)
    list
  end

  def accept(socket) do
    Logger.info("Accepting results on port........")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    IO.inspect data
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    IO.inspect socket
    IO.puts("Connection established..............")


    serve(socket)
  end
end

 Dos1Client.make_connections(4043)
