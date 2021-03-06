#include "cppdefs.h"
!-----------------------------------------------------------------------
!BOP
!
! !ROUTINE: 0D biogeochemical driver --- the main program  \label{sec:main}
!
! !INTERFACE:
   program main
!
! !DESCRIPTION:
! TODO
!
! !USES:
   use time
   use fabm_0d
   use fabm_version
#ifdef NETCDF4
   use netcdf
#endif
!
   IMPLICIT NONE
!
! !REVISION HISTORY:
!  Original author(s): Jorn Bruggeman
!
!EOP
!
! !LOCAL VARIABLES:
   character(LEN=8)          :: datestr
   real                      :: t1=-1,t2=-1
!
!-----------------------------------------------------------------------
!BOC
   call CPU_Time(t1)
   call Date_And_Time(datestr,timestr)
   STDERR LINE
   STDERR '0D FABM driver (using GOTM infrastructure)'
   STDERR 'FABM version:   ',git_commit_id,' (',git_branch_name,' branch)'
#ifdef NETCDF4
   LEVEL0 'NetCDF version: ',trim(NF90_INQ_LIBVERS())
#endif
   STDERR 'Started on  ',datestr,' ',timestr
   STDERR LINE

   call init_run()
   call time_loop()
   call clean_up(ignore_errors=.false.)

   call CPU_Time(t2)
   call Date_And_Time(datestr,timestr)
   STDERR LINE
   STDERR 'Finished on ',datestr,' ',timestr
   STDERR 'CPU-time was in loop:  ',t2-t1,' seconds'
   STDERR 'Sim-time/CPU-time:     ',simtime/(t2-t1)
   STDERR LINE

   end
!EOC

!-----------------------------------------------------------------------
! Copyright by the GOTM-team under the GNU Public License - www.gnu.org
!-----------------------------------------------------------------------
