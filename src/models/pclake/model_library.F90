!*******************************************************************************
!*                                                                             *
!* pclake_model_library.F90                                                 *
!*                                                                             *
!* Developed by :                                                              *
!*     Aquatic Ecology and Water Quality Management                            *
!*     Wageningen University,Netherland                                        *
!*     Bioscience-Silkeborg                                                    *
!*     Aarhus University,Denmark                                               *
!*     Center of Lake Restoration(CLEAR)                                       *
!*     Southern Denmark University,Denmark                                     *
!*     Copyright by the PCLake_FABM group @AU-silkeborg                        *
!*     under the GNU Public License - www.gnu.org                              *
!*                                                                             *
!*      Created March 2014                                                     *
!*-----------------------------------------------------------------------------*
!*-----------------------------------------------------------------------------*
!* If you have questions and suggestions regarding this model, please write to *
!*      Fenjuan Hu: fenjuan@bios.au.dk                                             *
!*      Dennis Trolle:dtr@bios.au.dk                                           *
!*      Karsten Bolding:bold@bios.au.dk                                        *
!*-----------------------------------------------------------------------------*
!*******************************************************************************

module pclake_model_library

   use fabm_types, only: type_base_model_factory,type_base_model
 
   use pclake_abiotic_water
   use pclake_abiotic_sediment
   use pclake_phytoplankton_water
   use pclake_phytoplankton_sediment
   use pclake_macrophytes
   use pclake_foodweb_water
   use pclake_foodweb_sediment
   use pclake_auxilary

   implicit none

   private

   type,extends(type_base_model_factory) :: type_factory
      contains
      procedure :: create
   end type

   type (type_factory),save,target,public :: pclake_model_factory

contains

   subroutine create(self,name,model)
      class (type_factory),intent(in) :: self
      character(*),        intent(in) :: name
      class (type_base_model),pointer :: model

   
    !NULLIFY(model)
    
      select case (name)
         case ('abiotic_water');          allocate(type_pclake_abiotic_water::model);
         case ('abiotic_sediment');       allocate(type_pclake_abiotic_sediment::model);
         case ('phytoplankton_water');    allocate(type_pclake_phytoplankton_water::model);
         case ('phytoplankton_sediment'); allocate(type_pclake_phytoplankton_sediment::model);
         case ('macrophytes');            allocate(type_pclake_macrophytes::model);
         case ('foodweb_water');          allocate(type_pclake_foodweb_water::model);
         case ('foodweb_sediment');       allocate(type_pclake_foodweb_sediment::model);
         case ('auxilary');               allocate(type_pclake_auxilary::model);

         case default
            call self%type_base_model_factory%create(name,model)
       end select
   end subroutine create

end module

!------------------------------------------------------------------------------
! Copyright by the FABM_PCLake-team under the GNU Public License - www.gnu.org
!------------------------------------------------------------------------------
