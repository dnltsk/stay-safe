/*
* HomePage
*
* This is the first thing users see of our App, at the '/' route
*
* NOTE: while this component should technically be a stateless functional
* component (SFC), hot reloading does not currently support SFCs. If hot
* reloading is not a necessity for you then you can refactor it and remove
* the linting exception.
*/

import React from 'react';
import 'whatwg-fetch';
import moment from 'moment';

import ServiceBox from 'components/ServiceBox/ServiceBox';

import 'containers/App/App.scss';

/* eslint-disable react/prefer-stateless-function */
export default class HomePage extends React.PureComponent {
  constructor(props) {
    super(props);

    this.basetime = '2018-06-21 07:00:00';

    this.state = {
      repetition: 0,
      time: this.basetime,
      east: null,
      west: null,
    };

    this.sendRequest = this.sendRequest.bind(this);
  }

  sendRequest() {
    const self = this;

    fetch(
      `http://localhost:8000/timetable/at/${moment(this.basetime)
        .add(1 * this.state.repetition, 'minutes')
        .format('YYYY-MM-DD_hh:mm:ss')}`,
    )
      .then(response => response.json())
      .then(json => {
        const east = {};
        const west = {};

        json.timetable.map(stop => {
          if (stop.platform === 1 || stop.platform === 2) {
            // This is on the east
            east[stop.name] = stop;
          } else if (stop.platform === 3 || stop.platform === 4) {
            // This is on the west
            west[stop.name] = stop;
          } else if (east[stop.name]) west[stop.name] = stop;
          else if (west[stop.name]) east[stop.name] = stop;
          else {
            west[stop.name] = stop;
            east[stop.name] = stop;
          }
          return null;
        });

        self.setState({
          east,
          west,
          time: json.time,
          repetition: self.state.repetition + 1,
        });
      });
  }

  componentWillMount() {
    this.sendRequest();
    setInterval(this.sendRequest, 1500);
  }

  renderServices(side) {
    return stops.map(
      stop =>
        side ? (
          <ServiceBox
            key={`service-${stop.name}`}
            color={stop.color}
            name={stop.name}
            platform={side[stop.name].platform}
            sector={side[stop.name].sector}
            time={side[stop.name].arrival}
            refTime={this.state.time}
          />
        ) : null,
    );
  }

  render() {
    return (
      <div className="app">
        <div className="app__container">
          <div>
            <h2>
              <span>via Hauptbahnhof</span>
            </h2>
            <div className="app__row">
              {this.renderServices(this.state.east)}
            </div>
          </div>
          <div>
            <h2>
              <span>via Oerlikon / via Altstetten</span>
            </h2>
            <div className="app__row">
              {this.renderServices(this.state.west)}
            </div>
          </div>
        </div>
      </div>
    );
  }
}

const stops = [
  {
    color: '#0090d4',
    name: 'S3',
  },
  {
    color: '#58b4cd',
    name: 'S5',
  },
  {
    color: '#7b4896',
    name: 'S6',
  },
  {
    color: '#fdbf22',
    name: 'S7',
  },
  {
    color: '#00a141',
    name: 'S9',
  },
  {
    color: '#b8a2ce',
    name: 'S11',
  },
  {
    color: '#e32213',
    name: 'S12',
  },
  {
    color: '#ceb18d',
    name: 'S15',
  },
  {
    color: '#74bc75',
    name: 'S16',
  },
  {
    color: '#a2cbee',
    name: 'S21',
  },
];
