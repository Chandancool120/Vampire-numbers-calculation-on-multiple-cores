Dos1
Group Members:
--------------
Chandan Chowdary (UFID-6972-9002) Gayathri Manogna Isireddy (UFID-9124-0699) 
The goal of this project is to compute Vampire numbers within in a given range using Actor Model in Elixir.

Project Hierarchy:
------------------
Please refer the project folder.

Instruction to run code:
------------------------
The following command is used to run the code:
mix run lib/proj1.ex 100000 200000
The output displayed are the Vampire numbers and their fangs.
The logic that we have used is as follows:
Let us say the problem is to find vampire numbers between 100000 and 200000. For this, we have are first finding out the length of each fang of a number if it is a vampire number. In this range it would be 3. After this we are finding out the multiplication result of all the pairs of numbers and hence checking if the value of multiplication result lies in between the range.
In our example problem we are finding out the multiplication values of all the pairs possible between 100 and 999 and hence checking the value lies between 100000 and 200000. In this way we need not process each number which results in less computation time.
The pilot of the program lies in dos1.ex file.
The command mix run lib/dos1.ex 100000 200000 will initiate the process and eventually prints the results.
Number of workers created and Size of the work unit:
The number of workers that we have created depends on the input range. For each worker a range of numbers within the initial range would be given to work on. For example if the range is 100000 to 200000, the iterable numbers are 100 to 999 which is 900. So for each worker we are assigning 1 unit which results in creating of 900 workers. 
Number of workers eventually increases depending on the range. For a range of 1000000000 to 200000000 we are creating 10000 workers.
This size of the worker is determined basing on the tests that we run on the code. The percentage of ranges of inputs given to a worker are changed randomly and checked which suits better.

Results:
 --------
Please refer project folder.

Running Time for the application:
--------------------------------
For the inputs 100000 to 200000 the real, user and sys time that we obtained are as follows:
real 0m1.939s
user 0m5.942s
sys 0m0.409s 
Running Time = (User time + System Time)/Real Time=(5.942+0.409)/1.939 = 3.275
on a quad core system.

The Largest problem that we managed to solve:
---------------------------------------------
We were able to run a range of 10,000,000 to 100,000,000 within 4 mins of user time. The ratio of cpu is 3.334 on a quad core system.


For the bonus part:
-------------------

We set the code in 3 different machines. We managed the connections between these machines using Supervisor and GenSever. 
We have a single client and 2 servers. Client sends the range of numbers to both the servers by dividing the range between the two servers. One server will calculate one half and the other server
will calculate the other half. All these results are sent to the client supervisor and the results are combined and printed to the terminal.

Both the server_workers will create still more number of workers in their respective local systems. These results are combined in the respective supervisors and sent to the client machine.
The same process will be followed by the other server as well.

Communication between these machines is done by using 3 way handshaking.

To run the code in different machines:
--------------------------------------
First run the servers in two machines.
In both the systems go to doc1 folder and execute the following command --> mix run lib/serverfile.ex
With this command the servers will be up and ready to get input from the client.

Now run the code in the client machine using the following command --> elixir clientsupervisor.ex

Now the client is ready to send the data and rest all the process will be taken care by client itself.

To change the server addresses, go to line numbers 9 and 10 in clientsupervisor.ex and change the server ip addresses. 
Within a few minutes both the servers will calculate the results and sends the data back to the client.


Below is the YouTube link for the demo video.

https://www.youtube.com/watch?v=gxSxNLWPclY&feature=youtu.be



