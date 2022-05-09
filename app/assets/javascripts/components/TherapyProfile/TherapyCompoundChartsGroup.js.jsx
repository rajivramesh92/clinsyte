const TherapyCompoundChartsGroup = ({ tagsWithCompounds }) => {

  var renderTagWithCompounds = (tagWithCompounds) => {
    return (
      <li className = 'list-group-item'>
        <div className = 'panel-footer'>
          { tagWithCompounds.tag.name }
        </div>
        <div>
          <TherapyCompoundChart chartName = { tagWithCompounds.tag.name + 'LineBoxChart' }
           compounds = { tagWithCompounds.compounds }
          />
        </div>
      </li>
    );
  }

  return (
    <div className = 'list-group'>
      { renderItems(tagsWithCompounds, renderTagWithCompounds) }
    </div>
  );
}

TherapyCompoundChartsGroup.propTypes = {
  tagsWithCompounds: PropTypes.array.isRequired
}
