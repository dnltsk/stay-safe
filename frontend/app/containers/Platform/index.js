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

import 'containers/App/App.scss';
import 'containers/Platform/Platform.scss';

/* eslint-disable react/prefer-stateless-function */
export default class Platform extends React.PureComponent {
  constructor(props) {
    super(props);

    this.state = {};
  }

  componentWillMount() {}

  render() {
    return (
      <div className="container-fluid p-0 fixed-top">
        <section className="resume-section">
          <div className="header">
            <span className="trainTime" />
            <span className="trainDestination" />
            <span className="trainLine" />
          </div>

          <div className="row">
            <div className="col-sm-2 text-center nopadding">
              <div className="plate">
                <span className="sector">A</span>
              </div>
              <div className="track" />
              <div className="platform">
                <div className="fill0" />
              </div>
            </div>
            <div className="col-sm-2 text-center nopadding">
              <div className="plate">
                <span className="sector">B</span>
              </div>
              <div className="track" />
              <div className="platform">
                <div className="fill0" />
              </div>
            </div>
            <div className="col-sm-2 text-center nopadding">
              <div className="plate">
                <span className="sector">C</span>
              </div>
              <div className="track" />
              <div className="platform">
                <div className="fill0" />
              </div>
            </div>
            <div className="col-sm-2 text-center nopadding">
              <div className="plate">
                <span className="sector">D</span>
              </div>
              <div className="track" />
              <div className="platform">
                <div className="fill0" />
              </div>
            </div>
            <div className="col-sm-2 text-center nopadding">
              <div className="plate">
                <span className="sector selected">E</span>
              </div>
              <div className="track" />
              <div className="platform">
                <div className="fill0" />
              </div>
            </div>
            <div className="col-sm-2 text-center nopadding">
              <div className="plate">
                <span className="sector">F</span>
              </div>
              <div className="track" />
              <div className="platform">
                <div className="fill0" />
              </div>
            </div>
          </div>

          <div className="train">
            <div className="car" />
            <div className="car" />
            <div className="car" />
            <div className="car" />
            <div className="car" />
            <div className="car" />
            <div className="locomotive" />
          </div>

          <div className="marker">
            <div className="top" />
            <div className="line" />
            <div className="bottom" />
          </div>
        </section>
      </div>
    );
  }
}
