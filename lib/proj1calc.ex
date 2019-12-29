defmodule StartCalc do
  use Application
  def pilot(partNo,startNo,endNo) do
		# nos = System.argv()
		# nos = Enum.map(nos,fn(x)->
		# 	String.to_integer(x)
		# end)
		# startNo = Enum.at(nos,0)
    # endNo = Enum.at(nos,1)
    tpls = BaseSupervisorCalc.start_link(partNo,startNo,endNo)
    IO.inspect tpls
    children = Supervisor.which_children(elem(tpls,1))
		list = Enum.map(children,fn(x)->
			BasicGenServer.get_vamp_fangs(elem(x,1))
    end)
    IO.inspect list
		list = Enum.map(list,fn(x)->
			if length(x)!=0 do
				x
			else
				[]
			end
		end)
		list = Enum.uniq(list) -- [[]]
		list = Enum.chunk_every(List.flatten(list),3)
		list = Enum.map(list, fn(x)->
			Enum.sort(x)
		end)
		new_list = Enum.map(list, fn(x)->
			Enum.at(x,0)*Enum.at(x,1)
		end)
		dup_list = new_list -- Enum.uniq(new_list)
		temp = if length(dup_list)!=0 do
			temp = Enum.map(dup_list, fn(dup)->
				_temp = Enum.map(list, fn(act)->
					if dup == Enum.at(act,2) do
						[dup,Enum.at(act,0),Enum.at(act,1)]
					else
						[]
					end
				end)
			end)
			temp
		else
			[]
		end
		temp = Enum.map(temp, fn(x)->
			List.flatten(x)
		end)
		temp = Enum.uniq(temp)
		temp = temp -- [[]]
		temp = Enum.map(temp, fn(x)->
			Enum.chunk_every(x,3)
		end)
		list = Enum.map(list,fn(x)->
			if Enum.member?(dup_list,Enum.at(x,2)) do
				[]
			else
				Enum.reverse(x)
			end
		end)
		list = Enum.uniq(list) -- [[]]
		temp = Enum.map(temp, fn(x)->
			dummy_list = List.flatten(x)
			_dummy_list = Enum.uniq(dummy_list)
		end)
		list = list ++ temp
		list = Enum.map(list,fn(x)->
			List.to_tuple(x)
    end)
		list = List.keysort(list,0)
		Enum.each(list,fn(x)->
			IO.puts(Enum.join(Tuple.to_list(x)," "))
    end)
    {:ok,self(),list}
  end
end

# Dos1.start(1000,2000)
