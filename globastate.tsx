import React, { createContext, useContext, ReactNode } from 'react';
import { useProfile } from './hooks/useProfile'; // Adjust the import path as needed
import { useQueryClient } from 'react-query';

interface GlobalStateProps {
  subscriberId: number | null;
  refetchProfile: () => void;
}

const GlobalStateContext = createContext<GlobalStateProps | undefined>(undefined);

export const GlobalStateProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const { data: profile, refetch } = useProfile();
  const queryClient = useQueryClient();

  const subscriberId = profile?.subscriberId ?? null;

  const refetchProfile = () => {
    queryClient.invalidateQueries('profile'); // Adjust if your query key is different
    refetch();
  };

  return (
    <GlobalStateContext.Provider value={{ subscriberId, refetchProfile }}>
      {children}
    </GlobalStateContext.Provider>
  );
};

export const useGlobalState = (): GlobalStateProps => {
  const context = useContext(GlobalStateContext);
  if (!context) {
    throw new Error('useGlobalState must be used within a GlobalStateProvider');
  }
  return context;
};
