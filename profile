import { useEffect, useState } from "react";
import styles from "./Profile.module.css";
import FormStyles from "./../../../../../FormFields.module.css";
import { useForm, FormProvider } from "react-hook-form";
import { toast, ToastContainer } from "react-toastify";
import { Input } from "../../../../../textfield/Input";
import SolidButton from "../../../../../buttons/SolidButton";
import StandardLayout from "../../../../../standardlayout/StandardLayout";
import FormLabel from "../../../../../label/FormLabel";
import CountryDropdown from "../../../../../CountryDropdown";
import ParishDropdown from "../../../../../ParishDropdown";
import PostOfficeDropdown from "../../../../../PostOfficeDropdown";
import useParishes from "../../../../../../hooks/useParishes";
import usePostOffices from "../../../../../../hooks/usePostOffice";
import useFetchCountries from "../../../../../../hooks/useFetchCountries";
import { ProfileDetails } from "../../../../../../react-query/services/profileDetailsService";
import {
  useFetchProfileDetails,
  useUpdateProfile,
} from "../../../../../../hooks/useProfile";
import ModalError from "../../../../../modals/ModalError";
import LoadingModal from "../../../../../modals/loadingModal/Loader";
import Loader from "../../../../../modals/loadingModal/Loader";

const Profile = () => {
  const {
    data: profile,
    isLoading: isProfileLoading,
    isRefetching,
    error: profileError,
  } = useFetchProfileDetails();
  const { data: parishes } = useParishes();
  const [parishCode, setParishCode] = useState("");
  const { data: postOffices, refetch: refetchPostOffices } =
    usePostOffices(parishCode);
  const { mutate: updateProfileDetails, isLoading: isUpdating } =
    useUpdateProfile();
  const [formError, setFormError] = useState<string | undefined>(undefined);

  const methods = useForm<ProfileDetails>({ defaultValues: profile });
  const {
    register,
    handleSubmit,
    watch,
    setValue,
    reset, // Used to reset the form with new default values
    formState: { errors, isDirty },
  } = methods;

  const selectedParishName = watch("parish");
  const selectedPostOfficeName = watch("postOffice");
  const selectedCountryName = watch("country");

  const { data: countries } = useFetchCountries(selectedCountryName);

  useEffect(() => {
    if (profile) {
      reset(profile); // Reset form with the latest profile data
      setParishCode(profile.parishCodeStr || "");
    }
  }, [profile, reset]);

  useEffect(() => {
    if (parishes && selectedParishName) {
      const foundParish = parishes.find((p) => p.name === selectedParishName);
      if (foundParish) {
        setValue("parishCodeStr", foundParish.code);
        setParishCode(foundParish.code);

        //setValue("postOffice", "");
      }
    }
  }, [selectedParishName, parishes, setValue]);

  // Refetch post offices when parishCode Changes
  useEffect(() => {
    if (parishCode) {
      refetchPostOffices();
    }
  }, [parishCode, refetchPostOffices]);

  const isFieldDirty = <T extends keyof ProfileDetails>(
    fieldName: T,
    currentValue: ProfileDetails[T]
  ): boolean => {
    return profile ? profile[fieldName] !== currentValue : false;
  };

  const isFormDirty =
    isDirty ||
    isFieldDirty("parish", selectedParishName) ||
    isFieldDirty("postOffice", selectedPostOfficeName) ||
    isFieldDirty("country", selectedCountryName);

  // useEffect(() => {
  //   if (profile && parishes?.length) {
  //     const initialParish = parishes.find(
  //       (p) => p.code === profile.parishCodeStr
  //     );
  //     if (initialParish) {
  //       reset({
  //         ...profile,
  //         parish: initialParish.name,
  //         parishCodeStr: initialParish.code,
  //       });
  //       setParishCode(initialParish.code);
  //     }
  //   }
  // }, [profile, parishes, reset]);

  // useEffect(() => {
  //   if (postOffices && selectedPostOfficeName) {
  //     const foundPostOffice = postOffices.find(
  //       (p) => p.name === selectedPostOfficeName
  //     );
  //     if (foundPostOffice) {
  //       setValue("postalCodeStr", String(foundPostOffice.id));
  //       setValue("postOffice", foundPostOffice.name);
  //     }
  //   }
  // }, [selectedPostOfficeName, postOffices, setValue]);

  useEffect(() => {
    if (countries && selectedCountryName) {
      const foundCountry = countries.find(
        (c) => c.name === selectedCountryName
      );
      if (foundCountry) {
        setValue("country", foundCountry.name);
      }
    }
  }, [selectedCountryName, countries, setValue]);

  //To display changed fields in Loading Modal
  // const changedFieldNames = Object.keys(dirtyFields);
  // console.log(changedFieldNames);
  const [showLoadingModal, setShowLoadingModal] = useState(false);
  const [modifiedFields, setModifiedFields] = useState({});

  const handleOpenModal = () => {
    setShowLoadingModal(true);
  };

  const handleCloseModal = () => {
    setShowLoadingModal(false);
  };

  // const onSubmit = () => {
  //   const modified = Object.entries(dirtyFields);
  //   const data = modified.map((key, val) => ({ key: key[0], value: key[1] }));

  //   console.log(data);
  //   setModifiedFields(modified);
  //   handleOpenModal();
  // };
  const onSubmit = (data: ProfileDetails) => {
    setFormError(undefined); // Clear any previous errors

    if (profile?.subscriberId) {
      updateProfileDetails(
        { profileDetails: data, subscriberId: profile.subscriberId },
        {
          onSuccess: () => {
            reset(data); // Reset form with submitted data
            setParishCode(data.parishCodeStr || ""); // Ensure parish code is updated
            // handleCloseModal();
            toast.success("Profile Details updated successfully!");
          },
          onError: (error: any) => {
            setFormError(error.message);
            toast.error(`Failed to update profile details - ${error}`);
          },
        }
      );
    }
  };
  // const handleProceed = (data: IProfile) => {
  //   try {
  //     console.log("waiting for update..");
  //     updateProfileDetailsMutation(data);
  //     handleCloseModal();
  //   } catch (error) {
  //     console.log("Error updating profile details", error);
  //   }
  // };
  // const onSubmit: SubmitHandler<IProfile> = (data) => {
  //   setModifiedFields(data);
  //   setShowLoadingModal(true);
  // };
  // const handleProceed = async () => {
  //   if (modifiedFields) {
  //     try {
  //       await updateProfileDetailsMutation.mutateAsync(modifiedFields);
  //       setShowLoadingModal(false);
  //       // Optionally show a success notification
  //     } catch (error) {
  //       console.log("Error updating profile details", error);
  //       // Optionally show an error notification
  //     }
  //   }
  // };

  // Form submit handler
  // const onSubmit = (data: IProfile) => {
  //   try {
  //     console.log(data);
  //     updateProfileDetailsMutation(data);
  //   } catch (error) {
  //     console.log("Error updating profile details", error);
  //   }
  // };
  useEffect(() => {
    console.log("Selected Parish", selectedParishName);
    console.log("Selected Post Office:", selectedPostOfficeName);
    console.log("Is Form Dirty:", isFormDirty);
  }, [selectedParishName, selectedPostOfficeName, isFormDirty]);

  if (isProfileLoading) return <Loader />;
  if (profileError) return <div>Error loading data</div>;

  return (
    <FormProvider {...methods}>
      <ToastContainer />
      <form onSubmit={handleSubmit(onSubmit)}>
        <StandardLayout
          header="Profile"
          footer={
            <SolidButton
              className={styles.saveBtn}
              type="button"
              onClick={() => {
                console.log("Save Button clicked");
              }}
              disabled={!isFormDirty || isUpdating}
            >
              {isUpdating ? "Saving..." : "Save Changes"}
            </SolidButton>
          }
        >
          {/* {(isRefetching || isUpdating) && <span className="loader"></span>} */}
          {(isRefetching || isUpdating) && <LoadingModal />}
          {/* <form onSubmit={onSubmit} className="profile-form"> */}
          {/* Profile Picture Currently disabled */}
          {/* <div className="profile-info">
                  <BsPersonCircle className="profile-icon" />
                  <div className="pp">
                    <h1 className="titles">Profile Picture</h1>{" "}
                    {/* SHOULD BE DYNAMIC 
                    <h5>PNG or JPG no bigger than 3MB in size.</h5>
                  </div>
                  <button className="changeBtn">Change Photo</button>{" "}
                  <button className="removeBtn">Remove Photo</button>
                </div> */}
          {/* <hr className="solid" /> */}
          <ModalError errorMessage={formError} />
          <h1 className={styles.titles}>General Information</h1>
          <div className={styles.formGrid}>
            <div className={styles["input-column"]}>
              <FormLabel id="fname" label="First Name" />
              <Input
                id="fname"
                type="text"
                placeholder="First Name"
                {...register("firstName", {
                  required: true,
                  minLength: 2,
                  maxLength: 25,
                })}
              />
              {errors.firstName?.type === "required" && (
                <p className={FormStyles.errors}>
                  The First name field is required
                </p>
              )}

              {errors.firstName?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Must be atleast 2 characters
                </p>
              )}
              {errors.firstName?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Must not exceed 25 characters
                </p>
              )}
            </div>

            <div className={styles["input-column"]}>
              <FormLabel id="lname" label="Last Name" />
              {/* <InputField
                id="lastName"
                label="lastName"
                formLabel="Last Name"
                type="text"
                register={register}
                errors={errors}
                isRequired={true}
              /> */}

              <Input
                {...register("lastName", {
                  required: true,
                  minLength: 2,
                  maxLength: 25,
                })}
                id="lname"
                type="text"
                placeholder="Last Name"
              />
              {errors.lastName?.type === "required" && (
                <p className={FormStyles.errors}>
                  The last name field is required
                </p>
              )}
              {errors.lastName?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Must be atleast 2 characters
                </p>
              )}
              {errors.lastName?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Must not exceed 25 characters
                </p>
              )}
            </div>
            <div className={styles["input-column"]}>
              <FormLabel id="email" label="Email Address" />
              {/* <TextField
                id="email"
                label="emailAddress"
                type="email"
                placeholder="Email Address"
                register={register}
                {...register("emailAddress", {
                  required: true,
                  pattern: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
                })}
                disabled
              /> */}
              <Input
                id="email"
                type="email"
                placeholder="Email Address"
                {...register("emailAddress", {
                  required: true,
                  pattern: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
                })}
                disabled
              />
              {/* {errors.EmailAddress && <p>{errors.EmailAddress.message}</p>} */}
            </div>
            <div className={styles["input-column"]}>
              <FormLabel id="telephone" label="Telephone" />
              <Input
                id="telephone"
                // label="telephone"
                type="number"
                placeholder="Telephone"
                // register={register}
                {...register("telephone", {
                  required: true,
                  minLength: 7,
                  maxLength: 10,
                })}
              />
              {/* {methods.formState.errors.telephone && (
                <p>{methods.formState.errors.telephone?.message}</p>
              )}{" "} */}
              {errors.telephone?.type === "required" && (
                <p className={FormStyles.errors}>
                  The Telephone field is required
                </p>
              )}
              {errors.telephone?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Must be atleast 7 characters
                </p>
              )}
              {errors.telephone?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Must not exceed 10 characters
                </p>
              )}
            </div>
          </div>
          <h1 className="titles">Address</h1>
          {/* <PostTest /> */}
          <div className={styles.formGrid}>
            <div className={styles["input-column"]}>
              <FormLabel id="streetNumber" label="Street" />
              <div className={styles["input-inline"]}>
                <Input
                  id="streetNumber"
                  // label="streetNumber"
                  type="text"
                  placeholder="Number"
                  // register={register}
                  {...register("streetNumber", {
                    required: true,
                    minLength: 1,
                    maxLength: 5,
                  })}
                  style={{ width: "100px" }}
                />

                <Input
                  id="streetName"
                  // label="streetName"
                  type="text"
                  placeholder="Street Name"
                  // register={register}
                  {...register("streetName", {
                    required: true,
                    minLength: 3,
                    maxLength: 25,
                  })}
                  style={{ width: "100%" }}
                />
              </div>

              {errors.streetNumber?.type === "required" && (
                <p className={FormStyles.errors}>
                  The Street Number field is required
                </p>
              )}
              {errors.streetNumber?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Must be atleast 1 characters
                </p>
              )}
              {errors.streetNumber?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Must not exceed 5 characters
                </p>
              )}
              {errors.streetName?.type === "required" && (
                <p className={FormStyles.errors}>
                  The Street Name field is required
                </p>
              )}
              {errors.streetName?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Name Must be atleast 3 characters
                </p>
              )}
              {errors.streetName?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Name Must not exceed 25 characters
                </p>
              )}
            </div>{" "}
            <div className={styles["input-column"]}>
              {" "}
              <FormLabel id="nearestTown" label="City/Town/District" />
              <Input
                id="nearestTown"
                // label="nearestTown"
                type="text"
                placeholder="City/Town/District"
                // register={register}
                {...register("nearestTown", {
                  required: true,
                  minLength: 7,
                  maxLength: 25,
                })}
              />
              {errors.nearestTown?.type === "required" && (
                <p className={FormStyles.errors}>
                  The City/Town/District field is required
                </p>
              )}
              {errors.nearestTown?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Must be atleast 7 characters
                </p>
              )}
              {errors.nearestTown?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Must not exceed 25 characters
                </p>
              )}
            </div>
            <div className={styles["input-column"]}>
              <FormLabel id="parish" label="Parish" />
              {/* won't change so put back change event in component*/}
              <ParishDropdown
                id="parish"
                // label="parish"
                // register={register}
                {...register("parish", { required: true })}
                //  value={selectedParishName}
              />

              {errors.parish?.type === "required" && (
                <p className={FormStyles.errors}>
                  The Parish field is required
                </p>
              )}
            </div>
            <div className={styles["input-column"]}>
              <FormLabel id="country" label="Country" />

              <CountryDropdown
                id="country"
                // label="country"
                // register={register}
                {...register("country", { required: true })}
                selectedCountryName={selectedCountryName}
                // disabled
              />
              {errors.country?.type === "required" && (
                <p className={FormStyles.errors}>
                  The Country field is required
                </p>
              )}
              {errors.country?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Must be atleast 7 characters
                </p>
              )}
              {errors.country?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Must not exceed 25 characters
                </p>
              )}
            </div>{" "}
            <div className={styles["input-column"]}>
              <FormLabel id="postOffice" label="Post Office" />
              <PostOfficeDropdown
                id="postOffice"
                // label="postOffice"
                // register={register}
                {...register("postOffice", { required: true })}
                selectedParishCode={parishCode}
              />
              {errors.postOffice?.type === "required" && (
                <p className={FormStyles.errors}>
                  The Post Office field is required
                </p>
              )}
            </div>
            <div className={styles["input-column"]}>
              <FormLabel id="postalCodeStr" label="Postal Code" isOptional />
              <Input
                id="postalCodeStr"
                // label="postalCodeStr"
                type="text"
                placeholder="Enter postal code"
                // register={register}
                {...register("postalCodeStr", {
                  required: false,
                  minLength: 1,
                  maxLength: 3, //just example
                })}
              />
              {errors.postalCodeStr?.type === "required" && (
                <p className={FormStyles.errors}>
                  The postal code field is required
                </p>
              )}
              {errors.postalCodeStr?.type === "minLength" && (
                <p className={FormStyles.errors}>
                  Must be atleast 1 characters
                </p>
              )}
              {errors.postalCodeStr?.type === "maxLength" && (
                <p className={FormStyles.errors}>
                  Must not exceed 3 characters
                </p>
              )}
            </div>
            {/* <input {...register("parishCodeStr")} placeholder="parishCodeStr " /> */}
            <input type="hidden" {...register("parishCodeStr")} />
          </div>{" "}
        </StandardLayout>
      </form>
    </FormProvider>
    // <div className={styles["delete-container"]}>
    //   <BsTrash3 className={styles["delete-btn"]} />

    //   <p>
    //     If you no longer want to use the COJ e-Services Portal,{" "}
    //     <Link to={""}>you can delete your account.</Link>
    //   </p>
    // </div>
  );
};

export default Profile;
