defmodule BaseClientSupervisor do
  use Supervisor
  def start_link(startNo,endNo) do
    Supervisor.start_link(__MODULE__,[startNo, endNo])
	end

  def init([min_limit,max_limit]) do
    children = [
      worker(ClientGenServer,[{192,168,0,248},4045,4046,0,min_limit,max_limit],[id: 4042, restart: :permanent]),
      worker(ClientGenServer,[{192,168,0,138},4043,4044,1,min_limit,max_limit],[id: 4043, restart: :permanent])
      # worker(ClientGenServer,[{192,168,0,248},4045,4046,1,min_limit,max_limit],[id: 4044, restart: :transient])
    ]
    tpls = supervise(children,strategy: :one_for_one)
  end
end

defmodule GenServerComputation do
  require Logger

  def make_connections(server,sport,cport,partNo,min_limit,max_limit) do

    server1 = server
    opts = [:binary, :inet, active: true, packet: :line,keepalive: true,
    reuseaddr: true]

    result = :gen_tcp.connect(server1, sport, opts)
    socket = case result do
      {:ok,socket}->socket
      {:error,reason}->false
    end

    list = if socket do
      msg = Integer.to_string(partNo)<> " " <> Integer.to_string(min_limit)<> " " <> Integer.to_string(max_limit)<>"\r\n"
      case :gen_tcp.send(socket, msg) do
        :ok -> :ok
        {:error, reason} ->
          Logger.error "Couldn't send message: #{inspect reason}"
      end

      ok = :gen_tcp.close(socket)
      port = cport
      {:ok, socket} =:gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
      IO.puts("listening on port...........")
      {:ok, client} = :gen_tcp.accept(socket,1200000)
      IO.puts("Connection established on client......")
      list = print_data(client,"do",[])
      list = list -- ["bye\r\n"]
      list
    else
      []
    end
    list
  end
  def print_data(client,"bye\r\n",list) do
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
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    IO.puts("Connection established..............")


    serve(socket)
  end
end

defmodule ClientGenServer do
  use GenServer

  def start_link(server,sport,cport,partNo,min_limit,max_limit) do

    # IO.puts("#{startNo} #{endNo}")
    :timer.sleep(5000)
		GenServer.start_link(__MODULE__,[server,sport,cport,partNo,min_limit,max_limit])
	end

	def get_vamp_fangs(pid) do
		GenServer.call(pid,:get_fangs,10*60*1000)
	end

	@impl true
  def handle_call(:get_fangs, _from, fangs) do
    Process.send_after(self(), :idle_timeout, 10*60*1000)
    {:reply, fangs, fangs}
	end

	@impl true
  def handle_cast({:new_range, server,sport,cport,partNo,min_limit,max_limit}, _) do
		fangs = GenServerComputation.make_connections(server,sport,cport,partNo,min_limit,max_limit)
		# IO.inspect GenServer.call(self(),:get_fangs)
    {:noreply, fangs}
  end

	def init([server,sport,cport,partNo,min_limit,max_limit]) do
    # IO.inspect self()
		GenServer.cast(self(),{:new_range,server,sport,cport,partNo,min_limit,max_limit})
		{:ok,"ok"}
  end
end

# tpls = BaseClientSupervisor.start_link(1,10000000)
# children = Supervisor.which_children(elem(tpls,1))
# 		list = Enum.map(children,fn(x)->
# 			ClientGenServer.get_vamp_fangs(elem(x,1))
#     end)
# fangs_list =  Enum.concat(Enum.at(list,0), Enum.at(list,1))
# fangs_list = Enum.sort(fangs_list)
# fangs_list = Enum.map(fangs_list,fn(x)->
#   x = String.replace(x,"\r","")
#     x = String.replace(x,"\n","")
#     x
#     IO.puts(x)
# end)
