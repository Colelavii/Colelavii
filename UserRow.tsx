import React from 'react';

interface UserRowProps {
  name: string;
  username: string;
  walletName: string;
  walletNumber: string;
  permission: string;
  onPermissionChange: (value: string) => void;
  onEdit: () => void;
  onRemove: () => void;
}

const UserRow: React.FC<UserRowProps> = ({
  name,
  username,
  walletName,
  walletNumber,
  permission,
  onPermissionChange,
  onEdit,
  onRemove,
}) => {
  return (
    <div className="row-content">
      <div className="name">
        {name}
        <br />
        <span style={{ fontSize: '12px', color: '#888' }}>{username}</span>
      </div>
      <div className="wallet">
        {walletName}
        <br />
        <span style={{ fontSize: '14px', fontFamily: 'Roboto', fontWeight: 400 }}>
          {walletNumber}
        </span>
      </div>
      <div className="permission">
        <Dropdown
          options={['User', 'Administrator']}
          selectedOption={permission}
          onChange={onPermissionChange}
        />
      </div>
      <div>
        <button onClick={onEdit}>Edit</button>
        <button onClick={onRemove}>Remove</button>
      </div>
    </div>
  );
};

export default UserRow;
