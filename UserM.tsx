import React, { useState } from "react";
import Modal, { ModalProps } from "../Modal";
import ModalHeader from "../ModalHeader";
import ModalBody from "../ModalBody";
import ModalFooter from "../ModalFooter";
import OutLinedButton from "../../buttons/OutLinedButton";
import SolidButton from "../../buttons/SolidButton";
import UpdateAddressStyle from "../updateModals/UpdateDeliveryAddressModal.module.css";
import { FormProvider, useForm } from "react-hook-form";
import FormLabel from "../../label/FormLabel";
import { Input } from "../../textfield/Input";
import FormStyles from "../../FormFields.module.css";
import { IAddUserToWallet } from "../../interface/IAddUserToWallet";
import Dropdown from "../../dropdown/Dropdown";
import useGetUsersOnWallet from "../../../hooks/useGetUsersOnWallet";
import Checkbox from "../../checkbox/Checkbox";
import useEwallets from "../../../hooks/useEwallets";

interface AddProps extends ModalProps {
  onAdd: (data: IAddUserToWallet) => void;
}

const AddUser: React.FC<AddProps> = ({ isOpen, onClose, onAdd }) => {
  const { data: users } = useGetUsersOnWallet();

  const [ewallet, setEwallet] = useState<number | undefined>();
  const { data, error, isLoading, refetch } = useEwallets(ewallet);
  const methods = useForm<IAddUserToWallet>();
  const {
    register,
    handleSubmit,
    reset, // Used to reset the form with new default values
    watch,
    formState: { errors, dirtyFields, isDirty },
  } = methods;

  const handleCancelClick = () => {
    if (onClose) onClose();
    reset();
  };
  //   const onSubmit: SubmitHandler<IAddUserToWallet> = (data) => {
  const onSubmit = (data: IAddUserToWallet) => {
    console.log("Data being submitted", data);
    onAdd(data);
  };
  if (!isOpen) return null;
  return (
    <Modal
      className={UpdateAddressStyle.modal}
      isOpen={isOpen}
      onClose={onClose}
    >
      <ModalHeader title="Add User" onClose={onClose} />
      <FormProvider {...methods}>
        <form onSubmit={handleSubmit(onSubmit)}>
          <hr className="solid" />

          <ModalBody>
            <div className={UpdateAddressStyle.generalInfo}>
              <div className={UpdateAddressStyle["input-column"]}>
                {" "}
                <FormLabel id="title" label="User Name(s)" />
                <Input {...register("username", { required: true })} />
                {errors.username?.type === "required" && (
                  <p className={FormStyles.errors}>
                    The Title field is required
                  </p>
                )}
                {errors.username?.type === "minLength" && (
                  <p className={FormStyles.errors}>
                    Must be atleast 3 characters
                  </p>
                )}
                {errors.username?.type === "maxLength" && (
                  <p className={FormStyles.errors}>
                    Must not exceed 25 characters
                  </p>
                )}
              </div>

              <div className={UpdateAddressStyle["input-column"]}>
                <FormLabel id="accountIdentifier" label="AccountIdentifier" />

                <Dropdown
                  id="alias"
                   selectedOption={data?.map((user) => user.id)}
                  value={data?.map((user) => user.id.toString())}
                  options={users?.map((user) => user.accountIdentifier)}
                />
              </div>
              {/* <div className={UpdateAddressStyle["input-column"]}>
                <FormLabel id="permission" label="Permission" />

                <Input {...register("permission", { required: true })} />
              </div> */}
              {/* <div className={UpdateAddressStyle["input-column"]}>
                <FormLabel id="walletId" label="Wallet Id" />
                {/* <Checkbox
                /> 
                <Input {...register("walletId", { required: true })} />
              </div> */}
              {/* <div className={UpdateAddressStyle["input-column"]}>
                {" "}
                <FormLabel id="firstName" label="First Name" />
                <Input
                  id="firstName"
                  type="text"
                  placeholder="First Name"
                  {...register("person.firstName", {
                    required: true,
                    minLength: 2,
                    maxLength: 25,
                  })}
                />
                {errors.person?.firstName?.type === "required" && (
                  <p className={FormStyles.errors}>
                    The First Name field is required
                  </p>
                )}
                {errors.person?.firstName?.type === "minLength" && (
                  <p className={FormStyles.errors}>
                    Must be atleast 2 characters
                  </p>
                )}
                {errors.person?.firstName?.type === "maxLength" && (
                  <p className={FormStyles.errors}>
                    Must not exceed 25 characters
                  </p>
                )}
              </div>
              <div className={UpdateAddressStyle["input-column"]}>
                {" "}
                <FormLabel id="lastName" label="Last Name" />
                <Input
                  id="lastName"
                  type="text"
                  placeholder="Last Name"
                  {...register("person.lastName", {
                    required: true,
                    minLength: 2,
                    maxLength: 25,
                  })}
                />
                {errors.person?.lastName?.type === "required" && (
                  <p className={FormStyles.errors}>
                    The Last Name field is required
                  </p>
                )}
                {errors.person?.lastName?.type === "minLength" && (
                  <p className={FormStyles.errors}>
                    Must be atleast 3 characters
                  </p>
                )}
                {errors.person?.lastName?.type === "maxLength" && (
                  <p className={FormStyles.errors}>
                    Must not exceed 25 characters
                  </p>
                )}
              </div> */}
            </div>
          </ModalBody>

          <ModalFooter className={UpdateAddressStyle.modalFooter}>
            <OutLinedButton
              className={UpdateAddressStyle.outlined}
              onClick={handleCancelClick}
              type="button"
            >
              Cancel
            </OutLinedButton>
            <SolidButton
              className={UpdateAddressStyle.solidBtn}
              type="submit"
              disabled={!isDirty}
            >
              Add User
            </SolidButton>
          </ModalFooter>
        </form>
      </FormProvider>
    </Modal>
  );
};

export default AddUser;
