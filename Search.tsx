import React from 'react';

interface SearchProps {
  placeholder: string;
  onSearch: (value: string) => void;
}

const Search: React.FC<SearchProps> = ({ placeholder, onSearch }) => {
  return (
    <input
      type="text"
      placeholder={placeholder}
      onChange={(e) => onSearch(e.target.value)}
    />
  );
};

export default Search;
