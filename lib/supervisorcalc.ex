defmodule BaseSupervisorCalc do
  use Supervisor
  def start_link(partNo,startNo,endNo) do
    Supervisor.start_link(__MODULE__,[partNo,startNo, endNo])
	end

	def init([partNo,min_limit,max_limit]) do
    startNo = min_limit
    endNo = max_limit
    list_of_numbers = Enum.map(startNo..endNo,fn(x)->
			if length(Integer.digits(x))>=4 do
				x
			else
				[]
			end
		end)
    list_of_numbers = Enum.uniq(list_of_numbers) -- [[]]
		startNo = hd(list_of_numbers)
    endNo = List.last(list_of_numbers)
		half_length = trunc(Float.floor(length(Integer.digits(startNo))/2))
		startNo = trunc(:math.pow(10,half_length-1))
		half_length = trunc(Float.ceil(length(Integer.digits(endNo))/2))
    endNo = trunc(:math.pow(10,half_length))-1
    batches = 1000
    actualEndNo = endNo
    list_of_numbers = Enum.map(startNo..endNo, fn(x)->
      x
    end)
    chunk_length = trunc(Float.ceil((endNo-startNo)/2))
    IO.puts("cl #{chunk_length}")
    list_of_numbers = Enum.at(Enum.chunk_every(list_of_numbers,chunk_length),partNo)
    endNo = List.last(list_of_numbers)
    startNo = hd(list_of_numbers)
    range = endNo-startNo
    IO.inspect startNo
    IO.inspect endNo
    IO.inspect actualEndNo
		batches = if range<1000 do
			1000
		else
			trunc(div(range,9))
		end
		IO.inspect batches
		batch_size = trunc(div(endNo-startNo,batches))
		batch_size = if batch_size == 0 do
			1
		else
			batch_size
		end
		list_of_numbers = Enum.map(startNo..endNo, fn(x)->
				x
    end)
    IO.inspect list_of_numbers
		list_of_numbers = Enum.chunk_every(list_of_numbers,batch_size)
		children = Enum.map(list_of_numbers, fn(x)->
			worker(BasicGenServer,[x,actualEndNo,min_limit,max_limit],[id: hd(x), restart: :transient])
		end)
		tpls = supervise(children,strategy: :one_for_one)
  end
end
