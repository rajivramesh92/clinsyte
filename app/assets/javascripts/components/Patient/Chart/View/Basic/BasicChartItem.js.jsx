const BasicChartItem = ({ basic }) => {

  var getBasicListItems = () => {

    var age = getAge(basic.birthdate);
    var sex = basic.gender || '-';
    var race = basic.ethnicity || '-';
    var height = basic.height  || '-';
    var weight = basic.weight  || '-';

    var items = { age, sex, race, height, weight };

    return _.map(items, (item, index) => {
      let key = heading = capitalize(index);
      let description = capitalize(item)
      return { key, heading, description };
    });
  }

  return (
    <div>
      { getChartItemHeading('Basic')  }
      <HorizonDescList listItems = { getBasicListItems() }/>
    </div>
  );
}
