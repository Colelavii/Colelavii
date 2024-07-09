import React from 'react';

interface SortProps {
  options: string[];
  selectedOption: string;
  onChange: (value: string) => void;
}

const Sort: React.FC<SortProps> = ({ options, selectedOption, onChange }) => {
  return (
    <select value={selectedOption} onChange={(e) => onChange(e.target.value)}>
      {options.map((option) => (
        <option key={option} value={option}>
          {option}
        </option>
      ))}
    </select>
  );
};

export default Sort;
