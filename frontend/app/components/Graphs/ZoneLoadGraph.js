import React from 'react';
import {
  ResponsiveContainer,
  BarChart,
  CartesianGrid,
  XAxis,
  Bar,
} from 'recharts';

import './Graphs.scss';

/* eslint-disable react/prefer-stateless-function */
export default class ZoneLoadGraph extends React.PureComponent {
  render() {
    const data = [
      { name: 'A1', density: 0.0 },
      { name: 'A2', density: 0.0 },
      { name: 'B1', density: 0.0 },
      { name: 'B2', density: 0.3 },
      { name: 'C1', density: 0.4 },
      { name: 'C2', density: 0.6 },
      { name: 'D1', density: 0.7 },
      { name: 'D2', density: 0.8 },
      { name: 'E1', density: 0.75 },
      { name: 'E2', density: 0.0 },
      { name: 'F1', density: 0.0 },
      { name: 'F2', density: 0.0 },
    ];

    return (
      <div className="graph histogram">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="name" />
            <Bar dataKey="density" fill="#ff0000" />
          </BarChart>
        </ResponsiveContainer>
      </div>
    );
  }
}
