program simulation_model_2
    use mpi
    implicit none

    integer :: ierr, rank, size, eval_rank, i
    integer :: array_length, dimensions_per_rank, start_idx, end_idx
    integer, parameter :: total_steps = 100
    integer :: step
    real(8), allocatable :: data(:)

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Rank of the evaluation software (last rank)
    eval_rank = size - 1

    ! Read array length from user (only rank 0 reads input)
    if (rank == 0) then
        print *, "Enter the length of the array:"
        read *, array_length
    end if

    ! Broadcast array length to all processes
    call MPI_Bcast(array_length, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

    ! Allocate the array
    allocate(data(array_length))

    ! Calculate the portion of the array each rank will handle
    dimensions_per_rank = array_length / (size - 1)  ! Exclude the evaluation rank
    start_idx = rank * dimensions_per_rank + 1
    end_idx = (rank + 1) * dimensions_per_rank

    ! Handle the remainder if the array length is not divisible by the number of ranks
    if (rank == size - 2) then
        end_idx = array_length
    end if

    ! Simulation loop
    do step = 1, total_steps
        ! Each process computes its portion of the array
        data = 0.0d0  ! Initialize the array
        if (rank < size - 1) then  ! Exclude the evaluation rank
            data(start_idx:end_idx) = [(real(rank + 1, 8) * step * i, i = start_idx, end_idx)]
        end if

        ! Check conditions (e.g., every 10 steps)
        if (mod(step, 10) == 0) then
            ! Send data to the evaluation software
            call MPI_Send(data, array_length, MPI_DOUBLE_PRECISION, eval_rank, 0, MPI_COMM_WORLD, ierr)
            print *, "Simulation (rank ", rank, "): Sent data at step ", step
            print *, data
        end if

        ! Sleep for some time to simply have enough time to read the terminal
        call small_sleep(0.1d0)
    end do

    ! Send termination signal to the evaluation software
    data = -1.0d0  ! Termination signal
    call MPI_Send(data, array_length, MPI_DOUBLE_PRECISION, eval_rank, 0, MPI_COMM_WORLD, ierr)
    print *, "Simulation (rank ", rank, "): Sent termination signal"

    ! Finalize MPI
    call MPI_Finalize(ierr)
    print *, "Simulation (rank ", rank, "): Finalized MPI"

    ! Deallocate the array
    deallocate(data)

end program simulation_model_2

subroutine small_sleep(sleep_duration)
    implicit none
    real(8), intent(in) :: sleep_duration  ! Sleep duration in seconds
    real(8) :: start_time, end_time

    ! Get the current time
    call cpu_time(start_time)

    ! Busy wait loop
    do
        call cpu_time(end_time)
        if (end_time - start_time >= sleep_duration) exit
    end do
end subroutine small_sleep
