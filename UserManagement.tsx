import React from 'react';
import StandardLayout from './StandardLayout';
import styles from './UserManagement.module.css';
import Checkbox from './Checkbox';
import Dropdown from './Dropdown';
import Search from './Search';
import Sort from './Sort';
import UserRow from './UserRow';

const UserManagement: React.FC = () => {
  const handleCheckboxChange = () => {
    // handle checkbox change
  };

  const handleDropdownChange = (value: string) => {
    // handle dropdown change
  };

  const handleSearch = (value: string) => {
    // handle search
  };

  const handleSortChange = (value: string) => {
    // handle sort change
  };

  const handleEditUser = () => {
    // handle edit user
  };

  const handleRemoveUser = () => {
    // handle remove user
  };

  return (
    <StandardLayout header="User Management">
      <div className={styles.container}>
        <div className={styles.row}>
          <Checkbox />
          <Dropdown options={['Wallet 1', 'Wallet 2']} selectedOption="Wallet 1" onChange={handleDropdownChange} />
          <Search placeholder="Search by name or wallet" onSearch={handleSearch} />
          <Sort options={['A-Z', 'Z-A']} selectedOption="A-Z" onChange={handleSortChange} />
        </div>

        <div className={`${styles.row} ${styles.rowHeader}`}>
          <div>Name</div>
          <div>Wallet</div>
          <div>Permission</div>
        </div>

        <UserRow
          name="John Doe"
          username="jdoe"
          walletName="Wallet 1"
          walletNumber="1234"
          permission="User"
          onPermissionChange={(value) => handleDropdownChange(value)}
          onEdit={handleEditUser}
          onRemove={handleRemoveUser}
        />
        {/* Add more UserRow components as needed */}
      </div>
    </StandardLayout>
  );
};

export default UserManagement;
