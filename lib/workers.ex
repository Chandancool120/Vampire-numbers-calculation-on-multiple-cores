defmodule BasicGenServer do
  use GenServer

  def start_link(list,endNo,min_limit,max_limit) do

		# IO.puts("#{startNo} #{endNo}")
		GenServer.start_link(__MODULE__,[list,endNo,min_limit,max_limit])
	end

	def get_vamp_fangs(pid) do
		GenServer.call(pid,:get_fangs)
	end

	@impl true
	def handle_call(:get_fangs, _from, fangs) do
    {:reply, fangs, fangs}
	end

	@impl true
  def handle_cast({:new_range, list,endNo,min_limit,max_limit}, _) do
		fangs = range(list,endNo,min_limit,max_limit)
		# IO.inspect GenServer.call(self(),:get_fangs)
    {:noreply, fangs}
  end

	def init([list,endNo,min_limit,max_limit]) do
		# IO.inspect self()
		GenServer.cast(self(),{:new_range,list,endNo,min_limit,max_limit})
		{:ok,"ok"}
  end

	def range(list,endNo,min_limit,max_limit) do
		list=Enum.map(list, fn(x)->
			list=Enum.map(x..endNo, fn(y)->
				[x,y]
			end)
		end)
		list = List.flatten(list)
		list = Enum.chunk_every(list,2)
		list = Enum.map(list, fn (tmp) ->
			# IO.inspect tmp,charlist: :as_lists
		# 	spawn_link fn -> (send me, { self(),check_vampire(tmp,min_limit,max_limit)}) end
		#    end)
		# |> Enum.map(fn (pid) ->
		# 	receive do
		# 		{ ^pid, result } ->
		# 			if length(elem(result,1))!=0 do
		# 				elem(result,1)
		# 			else
		# 				[]
    #       end
		# 	end
		# 	 end)
    {_var,result} = check_vampire(tmp,min_limit,max_limit)
    list = if length(result)!=0 do
						result
					else
						[]
          end
      list
    end)

		list = Enum.uniq(list)--[[]]
		list = Enum.map(list, fn(x)->
			List.flatten(x)
		end)
		list = Enum.uniq(list)
		list = list -- [[]]
		list = List.flatten(list)
		list = Enum.chunk_every(list,3)
		list
	end

  def check_vampire(tmp,low,high) do
		x=Enum.at(tmp,0)
		y=Enum.at(tmp,1)
		fangs = if rem(x, 10)!=0 or rem(y, 10)!=0 do
			number = x*y
			number_list = String.codepoints(Integer.to_string(number))
			number_list = Enum.map(number_list, fn(x)->
				{ret_val,_var}=Integer.parse(x)
				ret_val
			end)
			number_list = Enum.sort(number_list)
			res = if number>=low and number<=high and rem(length(Integer.digits(number)),2)==0 and length(Integer.digits(x))==length(Integer.digits(y)) do
							fangs_number_list = String.codepoints(Integer.to_string(x)) ++ String.codepoints(Integer.to_string(y))
							fangs_number_list = Enum.map(fangs_number_list, fn(x)->
								{ret_val,_var}=Integer.parse(x)
								ret_val
							end)
							fangs_number_list = Enum.sort(fangs_number_list)
							res = if number_list == fangs_number_list do
											[number,x,y]
										else
											[]
										end
							res
						else
							[]
			end
			res
		else
			[]
		end
		{self(),fangs}
	end
end
