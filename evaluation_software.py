from mpi4py import MPI
import numpy as np

def main():
    # Initialize MPI
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    size = comm.Get_size()

    # Evaluation software runs on the last rank
    if rank == size - 1:
        print(f"Evaluation software (rank {rank}): Started", flush=True)

        while True:
            # Probe for incoming messages
            status = MPI.Status()
            comm.Probe(source=MPI.ANY_SOURCE, tag=0, status=status)

            # Get the size of the incoming message
            count = status.Get_count(datatype=MPI.DOUBLE)

            # Receive the data
            data = np.empty(count, dtype=np.float64)
            comm.Recv(data, source=status.source, tag=0, status=status)


            # Process the data
            print(f"Received data = {np.array(data)}", flush=True)
            print(data.dtype)

            # Check for termination signal
            if data[0] == -1.0:
                print(f"Evaluation software (rank {rank}): Received termination signal", flush=True)
                break

        print(f"Evaluation software (rank {rank}): Exiting", flush=True)

if __name__ == "__main__":
    main()
