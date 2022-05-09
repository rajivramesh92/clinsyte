class BasicEditChartItem extends Component {

  getData() {
    var basic = this.refs;
    return {
      birthdate: getTimeInUTC(basic.birthdate.getDate()),
      gender: basic.sex.getValue(),
      ethnicity: basic.race.value || null,
      height: basic.height.value || null,
      weight: basic.weight.value || null
    }
  }

  getEditAge(date) {
    var d = new Date(Number(date));
    var defaultDate = { date: d.getDate(), month: d.getMonth() + 1, year: d.getFullYear() }
    return (
      <DateSelect defaultDate = { defaultDate }
        className = 'date-select col-md-4'
        start = { 1950 }
        end = { new Date().getFullYear() }
        ref = 'birthdate'
      />
    )
  }

  getEditSex(sex) {
    var genderOptions = _.map(['male', 'female'], g => {
      let key = value = display = capitalize(g);
      return { key, value, display };
    });

    return (
      <DropDown options = { genderOptions }
        className = 'form-control'
        defaultVal = { sex }
        ref = 'sex'
      />
    )
  }

  getEditRace(race) {
    return (
      <input type = 'text'
        className = 'form-control'
        defaultValue = { race }
        ref = 'race'
      />
    )
  }

  getEditHeight(height) {
    return (
      <input type = 'text'
        className = 'form-control'
        defaultValue = { height }
        ref = 'height'
      />
    )
  }

  getEditWeight(weight) {
    return (
      <input type = 'text'
        className = 'form-control'
        defaultValue = { weight }
        ref = 'weight'
      />
    )
  }

  getBasicEditListItems() {
    var basic = this.props.basic;
    return [
      { key: 1, heading: 'Birthdate:', description: this.getEditAge(basic.birthdate) },
      { key: 2, heading: 'Sex:', description: this.getEditSex(basic.gender) },
      { key: 3, heading: 'Race:', description: this.getEditRace(basic.ethnicity) },
      { key: 4, heading: 'Height:', description: this.getEditHeight(basic.height) },
      { key: 5, heading: 'Weight:', description: this.getEditWeight(basic.weight) }
    ]
  }

  render() {
    return (
      <div>
        { getChartItemHeading('Basic') }
        <HorizonDescList listItems = { this.getBasicEditListItems() } />
      </div>
    )
  }
}
