import 'package:flutter/material.dart';
import 'package:mathgame/services/game_points_service.dart';
import 'package:mathgame/utils/math_function.dart';
import 'dart:math';
import '../models/counting_game_model.dart';

final mathfunc = MathFunction();

Random random = Random();
int _num1 = random.nextInt(10) + 1;
int _num2 = random.nextInt(10);
int _req = _randNum(_num1 + _num2);
String _correctAns = 'Bạn đã làm đúng!';
String _wrongAns = 'Bạn đã làm sai. Thử lại?';

int _randNum(int x) {
  int rand = Random().nextInt(10) + 1;
  if (rand > x) {
    return _randNum(x); // Recursive call if the condition is met
  }
  return rand; // Return the number if it meets the condition
}

void _generateNumbers() {
  _num1 = random.nextInt(10) + 1; // Random number between 1 and 10
  _num2 = random.nextInt(10);      // Random number between 0 and 9
  _req = _randNum(_num1 + _num2); // Regenerate the required value
}

final List<ItemBasket> _items = [
  //todo: change images
  //todo: add, update points + current have pseudo points system
  //todo: instead of a nav bar (reuse for later) after pressing confirm,

  ItemBasket(
    uid: '1',
    name: 'Apple',
    imageItem: 'assets/apple.png',
    imageFull: 'assets/full_basket.png',
    imageEmpty: 'assets/empty_basket.png',
    amount: _num1,
  ),
];

@immutable
class CountingGame extends StatefulWidget {
  final String username;

  const CountingGame({super.key, required this.username});

  @override
  State<CountingGame> createState() => _CountingGameState();
}

class _CountingGameState extends State<CountingGame>
    with TickerProviderStateMixin {
  String resultMessage = '';
  final List<PlayerBasket> _playerItems = [
    PlayerBasket(
      name: 'Số quả táo có trong giỏ:',

      imageItem: 'assets/apple.png',
      imageFull: 'assets/full_basket.png',
      imageEmpty: 'assets/empty_basket.png',
      amount: _num2,
    ),
  ];

  final GlobalKey _draggableKey = GlobalKey();

  void _itemDroppedOnPlayerBasket({
    required ItemBasket item,
    required PlayerBasket customer,
  }) {
    if (customer.amount >= 0) {
      setState(() {
        customer.amount =
            customer.amount + 1; // Ensure amount is not null and increment by 1
        item.amount = item.amount - 1;
      });
    }
  }

  void _pItemDroppedOnItemBasket({
    required ItemBasket item,
    required PlayerBasket customer,
  }) {
    if (item.amount >= 0) {
      setState(() {
        item.amount =
            item.amount + 1; // Ensure amount is not null and increment by 1
        customer.amount = customer.amount - 1;
      });
    }
  }

  bool _showBadge = false;
  String _buttonText = "Xác nhận";

  void _checkAnswer(bool isCorrect) async{
    setState(() {
      if (isCorrect) {
        resultMessage = _correctAns;
        _showBadge = true; // Show the badge (Snackbar)
        _buttonText = "Tiếp tục"; // Change button text
      } else {
        resultMessage = _wrongAns;
      }
      _isButtonVisible = true;
      _isTextVisible = true;
    });

    if (_showBadge) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '+100 Points',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.amber[300],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2), // Snackbar duration
        ),

      );
      // Update points in the backend
      String username = widget.username; // Replace with actual username
      int pointsToAdd = 100; // Points to add, you can change this if needed

      bool success = await GameService().updatePoints(username, pointsToAdd);

      if (success) {
        print('Points updated successfully!');
      } else {
        print('Failed to update points.');
      }
    }
  }

  void _continueGame() {
    setState(() {
      _generateNumbers();
      _resetAmount();
      resultMessage = "";
      _showBadge = false;
      _buttonText = "Xác nhận";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      foregroundColor: Colors.white,
      title: Text(
        'Học đếm',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 0,
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMenuList(),
              ),
              _buildBottomRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuRow(item);
      },
    );
  }

  Widget _buildMenuRow(ItemBasket item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Cho đi $_req quả táo',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                // color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
        ),
        item.amount > 0
            ? Draggable<ItemBasket>(
                data: item,
                dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: DraggingListItem(
                  dragKey: _draggableKey,
                  photoProvider: AssetImage(item.imageItem),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: DragTarget<PlayerBasket>(
                    builder: (context, candidateCustomers, rejectedCustomers) {
                      return ReusableCard(
                        title: item.name,
                        image: item.hasItems
                            ? AssetImage(item.imageFull)
                            : AssetImage(item.imageEmpty),
                        highlighted: candidateCustomers.isNotEmpty,
                        itemCount: item.amount,
                      );
                    },
                    onAcceptWithDetails: (details) {
                      _pItemDroppedOnItemBasket(
                        customer: details.data,
                        item: item,
                      );
                    },
                  ),
                ),
              )
            : DragTarget<PlayerBasket>(
                builder: (context, candidateCustomers, rejectedCustomers) {
                return ReusableCard(
                  title: item.name,
                  image: item.hasItems
                      ? AssetImage(item.imageFull)
                      : AssetImage(item.imageEmpty),
                  highlighted: candidateCustomers.isNotEmpty,
                  itemCount: item.amount,
                );
              }, onAcceptWithDetails: (details) {
                _pItemDroppedOnItemBasket(
                  customer: details.data,
                  item: item,
                );
              }),
        Text(
          item.amount.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _playerItems.map(_buildBottomRowWithDropZone).toList(),
      ),
    );
  }

  void _resetAmount() {
    setState(() {
      _isButtonVisible = false; // Hide the button after pressing
      _isTextVisible = false;
      _items[0].amount = _num1; // Update item amount (adjust logic as needed)
      _playerItems[0].amount = _num2; // Update customer amount
    });
  }

  bool _isButtonVisible = true;
  bool _isTextVisible = true;

  Widget _buildBottomRowWithDropZone(PlayerBasket player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isTextVisible)
          Text(
            resultMessage,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: resultMessage == _correctAns ? Colors.green : Colors.red,
            ),
          ),
        (resultMessage == _wrongAns && _isButtonVisible)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.deepPurpleAccent, // Background color
                ),
                child: Text(
                  'Thử lại',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                ),
                onPressed: () {
                  _resetAmount();
                })
            : const SizedBox(),
        player.amount > 0
            ? Draggable<PlayerBasket>(
                data: player,
                dragAnchorStrategy: pointerDragAnchorStrategy,
                feedback: DraggingListItem(
                  dragKey: _draggableKey,
                  photoProvider: AssetImage(player.imageItem),
                ),
                child: DragTarget<ItemBasket>(
                  builder: (context, candidateItems, rejectedItems) {
                    return ReusableCard(
                      title: player.name,
                      image: player.hasItems
                          ? AssetImage(player.imageFull)
                          : AssetImage(player.imageEmpty),
                      itemCount: player.amount,
                      highlighted: candidateItems.isNotEmpty,
                    );
                  },
                  onAcceptWithDetails: (details) {
                    _itemDroppedOnPlayerBasket(
                      item: details.data,
                      customer: player,
                    );
                  },
                ),
                // ),
              )
            : DragTarget<ItemBasket>(
                builder: (context, candidateItems, rejectedCustomers) {
                  return ReusableCard(
                    title: player.name,
                    image:
                        player.hasItems
                            ? AssetImage(player.imageFull)
                            : AssetImage(player.imageEmpty),
                    itemCount: player.amount,
                    highlighted: candidateItems.isNotEmpty,
                  );
                },
                onAcceptWithDetails: (details) {
                  _itemDroppedOnPlayerBasket(
                    item: details.data,
                    customer: player,
                  );
                },
              ),
        // const SizedBox(height: 3),
        Text(
          player.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                // color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          player.amount.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(16), // Adjust the radius as needed
            ),
            backgroundColor: Colors.deepPurpleAccent, // Background color
          ),
          onPressed: _buttonText == "Xác nhận"
              ? () => _checkAnswer(player.amount == _req) // Simulate a correct answer
              : _continueGame,
          child: Text(
            _buttonText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
        ),
        const SizedBox(height: 70),
      ],
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.title,
    required this.image,
    this.highlighted = false,
    this.itemCount,
  });

  final String title;
  final ImageProvider image;
  final bool highlighted;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: Material(
        borderRadius: BorderRadius.circular(22),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 170,
                height: 140,
                child: Image(
                  image: image,
                  fit: BoxFit.fitHeight,
                ),
              ),
              // const SizedBox(height: 8),
              // Text(
              //   title,
              //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //         color: textColor,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18,
              //       ),
              // ),
              // // if (itemCount != null && itemCount! > 0) ...[
              // const SizedBox(height: 4),
              // Text(
              //   itemCount.toString(),
              //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //         color: textColor,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 26,
              //       ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.dragKey,
    required this.photoProvider,
  });

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 100,
          width: 100,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}