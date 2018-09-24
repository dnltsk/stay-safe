import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

import Watch from 'images/watch.svg';
import './ServiceBox.scss';

/* eslint-disable react/prefer-stateless-function */
export default class ServiceBox extends React.PureComponent {
  render() {
    const diff = moment(this.props.time, 'YYYY-MM-DD hh:mm:ss').diff(
      moment(this.props.refTime, 'YYYY-MM-DD hh:mm:ss'),
      'minutes',
    );

    console.log(diff);

    const Placeholder = () => (
      <div className="servicebox__platform">
        <div>
          <strong>No trains for the next hour.</strong>
        </div>
      </div>
    );

    return (
      <div className="servicebox__container">
        <div
          className={`servicebox ${
            !this.props.time || diff < 0 ? 'servicebox--frozen' : ''
          }`}
          style={{ background: this.props.color }}
        >
          <div
            className="servicebox__line"
            style={{ background: this.props.color }}
          >
            {this.props.name}
          </div>
          {this.props.time && diff > 0 ? (
            <div className="servicebox__platform">
              <div>
                <small>Head to:</small>
              </div>
              <div>
                <strong>
                  Platform {this.props.platform}
                  {this.props.sector ? `-${this.props.sector}` : ''}
                </strong>
              </div>
              <div className="servicebox__status">
                <img src={Watch} alt="watch" />
                <strong>{diff}m</strong>
              </div>
            </div>
          ) : (
            <Placeholder />
          )}
        </div>
      </div>
    );
  }
}

ServiceBox.propTypes = {
  color: PropTypes.string,
  name: PropTypes.string,
  platform: PropTypes.string,
  sector: PropTypes.string,
  time: PropTypes.string,
  refTime: PropTypes.string,
};
