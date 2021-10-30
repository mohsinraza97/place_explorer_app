import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/entities/place.dart';
import '../widgets/place_item_widget.dart';
import '../view_models/place_view_model.dart';
import '../../utils/constants/route_constants.dart';
import '../../utils/utilities/navigation_utils.dart';
import '../resources/app_strings.dart';

class PlaceListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PlaceViewModel>(context, listen: false);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, viewModel),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(AppStrings.title_place_list),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: AppStrings.tooltip_add_place,
          onPressed: () {
            NavigationUtils.push(
              context,
              RouteConstants.add_place,
            );
          },
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context, PlaceViewModel viewModel) {
    return FutureBuilder(
      future: viewModel.fetchPlaces(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return RefreshIndicator(
            onRefresh: () => viewModel.fetchPlaces(),
            color: Theme.of(context).primaryColor,
            child: Consumer<PlaceViewModel>(
              builder: (context, value, staticChild) {
                if (value.places.isEmpty) {
                  return staticChild ?? _buildEmptyView();
                }
                return _buildListView(value.places);
              },
              child: _buildEmptyView(),
            ),
          );
        }
      },
    );
  }

  Widget _buildListView(List<Place> places) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          final p = places.elementAt(i);
          return PlaceItemWidget(p);
        },
        itemCount: places.length,
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Text(
          AppStrings.no_places,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
