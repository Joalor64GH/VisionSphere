package backend.data;

class Option
{
    private var child:Alphabet;
    
    public var text(get, set):String;
    public var onChange:Void->Void = null;
    public var type(get, default):String = 'bool';
    public var scrollSpeed:Float = 50;

    private var variable:String = null;
    public var defaultValue:Dynamic = null;

    public var curOption:Int = 0;
    public var options:Array<String> = null;
    public var changeValue:Dynamic = 1;
    public var minValue:Dynamic = null;
    public var maxValue:Dynamic = null;
    public var decimals:Int = 1;
    public var displayFormat:String = '%v';
    public var description:String = '';
    public var name:String = 'Unknown';

    public function new(name:String, description:String = '', variable:String, type:String = 'bool', defaultValue:Dynamic = 'null value', ?options:Array<String> = null)
    {
        this.name = name;
        this.description = description;
        this.variable = variable;
        this.type = type;
        this.defaultValue = defaultValue;
        this.options = options;

        if (defaultValue == 'null value')
        {
            switch (type)
            {
                case 'bool':
                    defaultValue = false;
                case 'int' | 'float':
                    defaultValue = 0;
                case 'percent':
                    defaultValue = 1;
                case 'string':
                    defaultValue = '';
                    if (options.length > 0)
                        defaultValue = options[0];
            }
        }

        if (getValue() == null)
            setValue(defaultValue);
    }

    public function change()
    {
        if (onChange != null)
            onChange();
    }

    public function getValue():Dynamic
    {
        return Reflect.getProperty(SaveData, variable);
    }

    public function setValue(value:Dynamic)
    {
        Reflect.setProperty(SaveData, variable, value);
    }

    public function getVariable()
    {
        return variable;
    }

    public function setChild(child:Alphabet)
    {
        this.child = child;
    }
}