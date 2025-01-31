program simulation_model
    use mpi
    implicit none

    integer :: ierr, rank, size, eval_rank
    integer, parameter :: total_steps = 100
    integer :: step
    real(8), dimension(3) :: data

    ! Initialize MPI
    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

    ! Rank of the evaluation software (last rank)
    eval_rank = size - 1

    ! Simulation loop
    do step = 1, total_steps
        ! Simulate data: a vector evolving with time
        ! data = [1.0d0 * step, 2.0d0 * step, 3.0d0 * step]
        data = [1.0d0 * (rank + 1) * step, 2.0d0 * (rank + 1) * step, 3.0d0 * (rank + 1) * step]

        ! Check conditions (e.g., every 10 steps)
        if (mod(step, 10) == 0) then
            ! Send data to the evaluation software
            call MPI_Send(data, 3, MPI_DOUBLE_PRECISION, eval_rank, 0, MPI_COMM_WORLD, ierr)
            print *, "Simulation (rank ", rank, "): Sent data at step ", step
        end if

        ! Sleep for some time to simply have enough time to read the terminal
        call small_sleep(0.1d0)
    end do

    ! Send termination signal to the evaluation software
    data = [-1.0d0, 0.0d0, 0.0d0]
    call MPI_Send(data, 3, MPI_DOUBLE_PRECISION, eval_rank, 0, MPI_COMM_WORLD, ierr)
    print *, "Simulation (rank ", rank, "): Sent termination signal"

    ! Finalize MPI
    call MPI_Finalize(ierr)
    print *, "Simulation (rank ", rank, "): Finalized MPI"


end program simulation_model

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
