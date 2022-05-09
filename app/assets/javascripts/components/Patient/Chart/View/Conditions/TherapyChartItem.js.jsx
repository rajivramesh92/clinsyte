const TherapyChartItem = ({ treatmentPlans }) => {

  var renderTherapies = therapies => {
    var items = _.uniq(_.flatten(_.map(therapies, therapy => _.isEmpty(therapy.association_entities) ? [UNASSOCIATED_THERAPIES] : _.map(therapy.association_entities, e => e.entity_object.name))));

    var groupedTherapies = {};
    _.each(items, item => {
      groupedTherapies[item] = _.filter(therapies, therapy => _.any(therapy.association_entities, e => e.entity_object.name === item) || item === UNASSOCIATED_THERAPIES);
    });

    return _.map(groupedTherapies, (therapies, groupKey) => (
      <div title = { capitalize(groupKey) }
        key = { groupKey }
        Key = { groupKey }>
        <ul>
          { renderItems(_.unique(therapies, false, therapy => therapy.strain.id), therapy => (
              <li key = { therapy.id }>
                <Link to = { '/therapies/' + therapy.strain.id }>
                  { therapy.strain.name }
                </Link>
              </li>
            ))
          }
        </ul>
      </div>
    ));
  }

  var renderTherapyGroups = therapies => {
    if (_.isEmpty(therapies)) {
      return (
        <div className = 'text-center text-muted'>
          <em>No therapy added</em>
        </div>
      );
    }

    var therapyGroups = _.groupBy(therapies, therapy => _.first(therapy.association_entities) ? 'For ' + _.first(therapy.association_entities).entity_type + '(s)' : UNASSOCIATED_THERAPIES);

    return _.map(_.sortBy(_.keys(therapyGroups)), groupKey => (
      <div key = { groupKey }>
        <em className = 'font-size-14'>
          { groupKey != UNASSOCIATED_THERAPIES ? capitalize(groupKey) : 'Other therapies' }:
        </em>
        <Accordion id = { groupKey.replace(/\W/g, '') }
          key = { groupKey }>
          { renderTherapies(therapyGroups[groupKey]) }
        </Accordion>
      </div>
    ));
  }

  return (
    <div>
      { getChartItemHeading('Therapies') }
      { renderTherapyGroups(_.flatten(_.map(treatmentPlans, 'therapies'))) }
    </div>
  );
}

TherapyChartItem.propTypes = {
  treatmentPlans: PropTypes.array.isRequired
}

const UNASSOCIATED_THERAPIES = 'unassociated therapies';
