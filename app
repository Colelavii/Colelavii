import { useReducer, useState } from "react";
import {
  createBrowserRouter,
  Route,
  createRoutesFromElements,
  RouterProvider,
  Navigate,
} from "react-router-dom";
import Dashboard from "./components/eservice/eservsidebar/toolssidebar/dashboard/Dashboard";
import Applications from "./components/eservice/eservsidebar/toolssidebar/applications/Applications";
import EserviceLayout from "./container/eservice/eserviceLayout/EserviceLayout";
import Login from "./components/eservice/login/Login";
import SettingsLayout from "./container/settingsLayout/SettingsLayout";
import Settings from "./components/eservice/eservsidebar/toolssidebar/settings/Settings";
import Security from "./components/eservice/eservsidebar/toolssidebar/settings/security/Security";
import Profile from "./components/eservice/eservsidebar/toolssidebar/settings/profile/Profile";
import Notifications from "./components/eservice/eservsidebar/toolssidebar/settings/notifications/Notifications";
import SettingsError from "./container/settingsLayout/SettingsError";
import Ewallet from "./components/eservice/eservsidebar/toolssidebar/settings/ewallet/Ewallet";
import DeliveryAddresses from "./container/eservice/DeliveryAddresses";
import Messages from "./components/eservice/eservsidebar/toolssidebar/messages/Messages";
import { Parish } from "./hooks/useParishes";
import styles from "./App.module.css";
import UserManagement from "./components/eservice/eservsidebar/toolssidebar/settings/users/UserManagement";
import authReducer, {
  AuthAction,
  AuthState,
} from "./state-management/reducers/authReducer";
import AuthContext from "./state-management/contexts/authContext";
import PasswordTest from "./components/eservice/eservsidebar/toolssidebar/settings/security/PasswordTest";
import Recipients from "./container/eservice/Recipients";
import PaymentHistory from "./container/eservice/paymentHistory/PaymentHistory";

const initialState: AuthState = {
  username: undefined,
  subscriberId: undefined,
  emailAddress: undefined,
};

const App = () => {
  const [authState, authDispatch] = useReducer<
    React.Reducer<AuthState, AuthAction>
  >(authReducer, initialState);

  const router = createBrowserRouter(
    createRoutesFromElements(
      <Route
        path="/"
        element={
          <AuthContext.Provider value={{ authState, dispatch: authDispatch }}>
            <EserviceLayout />
          </AuthContext.Provider>
        }
        errorElement={<SettingsError />}
      >
        <Route index element={<Dashboard />} />
        <Route path="applications" element={<Applications />} />
        <Route path="message" element={<Messages />} />
        <Route path="settings" element={<SettingsLayout />}>
          {/* <Suspense fallback={<LoadingModal />}> */}
          <Route index element={<Navigate to="Profile" replace />} />
          <Route path="profile" element={<Profile />} />
          {/* </Suspense> */}
          <Route path="security" element={<PasswordTest />} />
          {/* <Route path="security" element={<Security />} /> */}
          <Route path="Delivery" element={<DeliveryAddresses />} />
          <Route path="Recipients" element={<Recipients />} />
          <Route path="notifications" element={<Notifications />} />
          <Route path="ewallet" element={<Ewallet />} />
          <Route path="users" element={<UserManagement />} />
          <Route path="PaymentHistory" element={<PaymentHistory />} />
          <Route path="settings" element={<Settings />} />
        </Route>
        <Route path="login" element={<Login />} />
      </Route>
    )
  );

  return (
    <div className={styles["white__bg"]}>
      {/* <div className={styles["gradient__bg"]}> */}
      <RouterProvider router={router} />
    </div>
  );
};

export default App;
 