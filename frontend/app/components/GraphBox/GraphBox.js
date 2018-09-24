import React from 'react';
import PropTypes from 'prop-types';

import './GraphBox.scss';

/* eslint-disable react/prefer-stateless-function */
export default class GraphBox extends React.PureComponent {
  render() {
    return (
      <div className="graphbox">
        <div className="graphbox__card">{this.props.children}</div>
      </div>
    );
  }
}

GraphBox.propTypes = {
  children: PropTypes.oneOfType([
    PropTypes.element,
    PropTypes.node,
    PropTypes.string,
  ]),
};
